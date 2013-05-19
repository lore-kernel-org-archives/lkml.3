Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab3ESSGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 14:06:50 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:56602 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab3ESSGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 14:06:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAPweEDzsCf3rQB_hZ2=OH_b8McYRY7VUit=j-1=aVSd7vbM+og@mail.gmail.com>
References: <CAPweEDxgT+ZygfPZDd8YePe7RurTU7o_UtiBqjUvCMimChpTug@mail.gmail.com>
	<1368918189923.dd7325ed@Nodemailer>
	<CAPweEDwYm6iQ1vJ_UwAC5pE-uwfnMDHR6wJ1VppW1wakmTMJGQ@mail.gmail.com>
	<CAOiHx=ksyGWYZhafde_5NqUf1wpyWKNc3rs5heFHsNKD8GhXGQ@mail.gmail.com>
	<CAPweEDzsCf3rQB_hZ2=OH_b8McYRY7VUit=j-1=aVSd7vbM+og@mail.gmail.com>
Date: Sun, 19 May 2013 14:06:48 -0400
Message-ID: <CAHeTLqapO-S9sGAKfwzgzqO87t7bpMKNAGt1LH_RtdEKt6=gBw@mail.gmail.com>
Subject: Re: Would like to form a pool of Linux copyright holders for faster
 GPL enforcement against Anthrax Kernels
From: Thomas Charron <twaffle@gmail.com>
To: "luke.leighton" <luke.leighton@gmail.com>
Cc: Jonas Gorski <jonas.gorski+gpl@gmail.com>,
        GPL Violations <legal@lists.gpl-violations.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 19, 2013 at 8:34 AM, luke.leighton <luke.leighton@gmail.com> wrote:
> On Sun, May 19, 2013 at 12:19 PM, Jonas Gorski
> <jonas.gorski+gpl@gmail.com> wrote:
>  that doesn't sound right.  actually, this is a very very important
> misunderstanding, jonas.
>
>  you *can* choose GPLv3 code.  what you can choose is: *only* those
> files of the linux kernel that are released under GPLv3.

  No,, you can't.  The second you do, you cannot use the GPLv2 code
with it *AT ALL*, making the code you chose to use for the GPLv3
worthless when used in conjunction with the kernel itself.  As such,
when you say, "I'm accepting the GPLv3 for this file", you need to now
immediately take that file, move it OUT of the kernel source tree, and
use it for whatever you like, but not under the Linux kernel, making
it, for the most part, worthless to you unless you are writing your
own software.

> many people point out that just because this is unlikely to result in
> success any time in the next 100 years, that nobody should bother even
> starting.

  Go house, but make sure to delete any GPLv2 code.  I suspect you'll
find you'll have a really hard time, as you won't have a kernel.

>> So any further licenses will never apply to any use in the kernel.
>
>  incorrect!!  logical assertion error!! :)  assert(ELOGICALCONCLUSIONBRAINFART)

  You go house, as your one guy making assertions on the Linux kernel
which has been supported and under active development for over 21
years now.

>> Only if somebody took your code out of the kernel and used it in a
>> separate GPLv3+ project, then the GPLv3+ license could and would
>> apply.
>
>  after reviewing the above pseudo-code i believe you'll agree that
> that's slightly misleading. one could also choose to leave the files
> in-place in the *same* project's source tree, and just not use any of
> the ones that were incompatibly-licensed.

  Correct, except that the kernel, the thing that actually *IS* the
software, won't exist in your tree any longer.

  Thomas
