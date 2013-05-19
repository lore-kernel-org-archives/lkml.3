Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab3ESMfB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 08:35:01 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:50488 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3ESMfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 08:35:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAOiHx=ksyGWYZhafde_5NqUf1wpyWKNc3rs5heFHsNKD8GhXGQ@mail.gmail.com>
References: <CAPweEDxgT+ZygfPZDd8YePe7RurTU7o_UtiBqjUvCMimChpTug@mail.gmail.com>
	<1368918189923.dd7325ed@Nodemailer>
	<CAPweEDwYm6iQ1vJ_UwAC5pE-uwfnMDHR6wJ1VppW1wakmTMJGQ@mail.gmail.com>
	<CAOiHx=ksyGWYZhafde_5NqUf1wpyWKNc3rs5heFHsNKD8GhXGQ@mail.gmail.com>
Date: Sun, 19 May 2013 13:34:59 +0100
Message-ID: <CAPweEDzsCf3rQB_hZ2=OH_b8McYRY7VUit=j-1=aVSd7vbM+og@mail.gmail.com>
Subject: Re: Would like to form a pool of Linux copyright holders for faster
 GPL enforcement against Anthrax Kernels
From: "luke.leighton" <luke.leighton@gmail.com>
To: Jonas Gorski <jonas.gorski+gpl@gmail.com>
Cc: Cole Johnson <coleharrisjohnson@gmail.com>, legal@lists.gpl-violations.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 19, 2013 at 12:19 PM, Jonas Gorski
<jonas.gorski+gpl@gmail.com> wrote:

> But dual license means the license taker may chose which license to
> apply, not that you can dictate which one to use.

 yes.

> And as long as any
> part of the kernel is GPLv2 (no +), (s)he can't choose anything except
> GPLv2, as GPLv2 and GPLv3 are incompatible.

 that doesn't sound right.  actually, this is a very very important
misunderstanding, jonas.

 you *can* choose GPLv3 code.  what you can choose is: *only* those
files of the linux kernel that are released under GPLv3.

 pseudo-algorithm in bash script and maybe a bit of python:

 $ filenames_gplv3 = `find . | xargs grep -l GPLv3`
 $ filenames_gplv2 = `find . | xargs grep -l GPLv2`
 $ files_to_delete = []
 $ for x in filenames_gplv2:
    if x not in filenames_gplv2:
        files_to_delete.append(x)
 $ for x in files_to_delete:
     rm $x

after that procedure is done, _then_ try doing a kernel compile, see
how far you get.

many people point out that just because this is unlikely to result in
success any time in the next 100 years, that nobody should bother even
starting.

> So any further licenses will never apply to any use in the kernel.

 incorrect!!  logical assertion error!! :)  assert(ELOGICALCONCLUSIONBRAINFART)

> Only if somebody took your code out of the kernel and used it in a
> separate GPLv3+ project, then the GPLv3+ license could and would
> apply.

 after reviewing the above pseudo-code i believe you'll agree that
that's slightly misleading. one could also choose to leave the files
in-place in the *same* project's source tree, and just not use any of
the ones that were incompatibly-licensed.

> Also GPLv2 + GPLv3+ == GPLv2+. And there are already plenty of
> examples in the kernel that are GPLv2+ licensed (try searching for "or
> later").

 very good point, jonas.

 l.
