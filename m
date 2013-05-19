Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3ESLUM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 07:20:12 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:46619 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab3ESLUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 07:20:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAPweEDwYm6iQ1vJ_UwAC5pE-uwfnMDHR6wJ1VppW1wakmTMJGQ@mail.gmail.com>
References: <CAPweEDxgT+ZygfPZDd8YePe7RurTU7o_UtiBqjUvCMimChpTug@mail.gmail.com>
 <1368918189923.dd7325ed@Nodemailer> <CAPweEDwYm6iQ1vJ_UwAC5pE-uwfnMDHR6wJ1VppW1wakmTMJGQ@mail.gmail.com>
From: Jonas Gorski <jonas.gorski+gpl@gmail.com>
Date: Sun, 19 May 2013 13:19:49 +0200
X-Google-Sender-Auth: pXZtEOjx5kcNjzk5oIx2hCmqRcY
Message-ID: <CAOiHx=ksyGWYZhafde_5NqUf1wpyWKNc3rs5heFHsNKD8GhXGQ@mail.gmail.com>
Subject: Re: Would like to form a pool of Linux copyright holders for faster
 GPL enforcement against Anthrax Kernels
To: "luke.leighton" <luke.leighton@gmail.com>
Cc: Cole Johnson <coleharrisjohnson@gmail.com>, legal@lists.gpl-violations.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 19, 2013 at 12:39 PM, luke.leighton <luke.leighton@gmail.com> wrote:
> On Sun, May 19, 2013 at 12:03 AM, Cole Johnson
> <coleharrisjohnson@gmail.com> wrote:
>>> question: what is the procedure for having that licensing explicitly
>>
>> added to the linux kernel sources?
>>
>> IIRC Linus said he will NOT use the GPLv3 for the kernel.
>
>  mr linus torvalds is one person.  he is not a god.  he does not
> dictate that which everyone else can choose to do.  if mr linus
> torvalds is telling everyone "he will not use the GPLv3 for the
> kernel" i.e. NOBODY may dual-license their copyright material in the
> linux kernel then he is *MASSIVELY* overstepping a serious boundary of
> both propriety and copyright law.  if i choose to release all
> copyright code under dual licenses then THAT IS MY RIGHT AND NO FUCKER
> IS GOING TO TELL ME OTHERWISE.
>
>  so, let's nip this in the bud and set it straight, ok?
>
>  i assume that what mr linus torvalds *meant* to say was "i have some
> code, it is under my copyright.  i personally choose not to release
> that copyright material under any license other than the GPLv2 and
> that is my choice and my right as the owner of that copyright
> material.  signed, mr linus torvalds".
>
>  that choice - made by mr linus torvalds - has *nothing to do with
> anybody else's choice*.
>
>  so the question remains, and i'd like an answer: what is the
> procedure for formally adding to the linux kernel that my copyrighted
> material is dual-licensed under both the GPLv2 and the GPLv3+?  do i
> submit a patch, and is it as simple as that?
>
>  unless.... unless what mr linus torvalds meant to say was, "i don't
> like the GPLv3+ license.  if any fucker wants to release linux kernel
> code under the GPLv3+ (as well as the GPLv2), they can fuck off.  in
> fact, they will be banned from submitting contributions that are not
> specifically GPLv2.  if they try to dual-license their code, it will
> not be accepted. i, linus torvalds, have spoken".  which i seriously
> seriously doubt, but there seems to be some implication that that's
> the case, here.

But dual license means the license taker may chose which license to
apply, not that you can dictate which one to use. And as long as any
part of the kernel is GPLv2 (no +), (s)he can't choose anything except
GPLv2, as GPLv2 and GPLv3 are incompatible.

So any further licenses will never apply to any use in the kernel.
Only if somebody took your code out of the kernel and used it in a
separate GPLv3+ project, then the GPLv3+ license could and would
apply.

Also GPLv2 + GPLv3+ == GPLv2+. And there are already plenty of
examples in the kernel that are GPLv2+ licensed (try searching for "or
later").


Jonas
