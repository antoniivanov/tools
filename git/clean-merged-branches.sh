git checkout main
git up origin main

branches=$(git branch -l | grep -v 'main')

upto_branches=()
failed_branches=()

for branch in $branches; do
    if [ "$branch" != 'main'  ];
    then
        echo ""
        echo "$branch"
        git checkout "$branch"
        if git up origin main ; then
            # git ls -n 3 | head
            if git branch --contains HEAD | grep main; then
                echo "Branch $branch up-to date with origin/main"
                upto_branches+=("$branch")
            else
                echo "Branch $branch has missing commits in origin/main"
            fi
        else
            git rebase --abort
            failed_branches+=("$branch")
        fi
    fi
done

echo "Failed to rebase branches:"
echo "${failed_branches[@]}"
echo ""
echo ""
echo "Ready branches:"
echo "${upto_branches[@]}"
