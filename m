Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933992Ab3D3XeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 19:34:08 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:50516 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933705Ab3D3XeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 19:34:05 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1304291237210.6626@tundra.namei.org>
References: <alpine.LRH.2.02.1304291237210.6626@tundra.namei.org>
Date: Tue, 30 Apr 2013 16:34:03 -0700
X-Google-Sender-Auth: I1rNtIKCVA29ZvbUP3moDPhszqc
Message-ID: <CA+55aFz2o8i+VnW_S8VBKVkLX1Pw7nQimqm+c6yOQjs-5zE3hA@mail.gmail.com>
Subject: Re: [GIT] Security subsystem updates for 3.10
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Morris <jmorris@namei.org>
Cc: LSM List <linux-security-module@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 28, 2013 at 7:48 PM, James Morris <jmorris@namei.org> wrote:
>
> Note: I can't figure out why the patch from Lai Jiangshan shows up twice
> in the shortlog.  Everything checks out otherwise.

Because you applied it twice. in two different branches.

It's there in both your "stage-for-3.10" and "ra-next" branch, commits
505f14f7b8d4 and 921f3ac4c3f2 respectively.

You then merged things in commit 9b0271d8ca4d ("Merge branch
'stage-for-3.10' of git://git.gitorious.org/smack-next/kernel into
ra-next") and it all merged without any conflicts because the patches
are identical and there wasn't any other work on top of it in either
branch. But that doesn't change the fact that there are two distinct
commits that just happen to have the same patch. So "git shortlog"
will show it.

I would seriously suggest using gitk regularly (limit it to just your
own stuff with something like "gitk origin.." or whatever) to see the
history of what you've done visually as often as possible, not only
does it show up very clearly if you do that, but it really helps to
have a feel for what you've done.

             Linus
