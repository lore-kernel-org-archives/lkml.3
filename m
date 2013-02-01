Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757687Ab3BAVhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 16:37:45 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:49327 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757227Ab3BAVhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 16:37:43 -0500
MIME-Version: 1.0
In-Reply-To: <50cfc309.64093c0a.7948.05b1@mx.google.com>
References: <50cfc309.64093c0a.7948.05b1@mx.google.com>
Date: Fri, 1 Feb 2013 23:37:41 +0200
Message-ID: <CAJL_dMt9JJY8AnYc3CsH8JdVy6GKmCo=E8sL6FoB12BnM4fvXw@mail.gmail.com>
Subject: Re: [PATCH 0/3] build 3.7 kernel without perl
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Rob Landley <rob@landley.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping ?
Rob, if nobody thake your patches then you must ping it to relevant
maintainers to be included in next.

On Tue, Dec 18, 2012 at 3:12 AM,  <rob@landley.net> wrote:
> Before 2.6.25 building Linux never required perl. This patch series removes
> the requirement from basic kernel builds (tested on i686, x86_64, arm, mips,
> powerpc, sparc, sh4, and m68k). Now updated to 3.7, with the UAPI stuff.
>
> Earlier versions of these patches were posted to the mailing list once or twice:
>
> http://lkml.indiana.edu/hypermail/linux/kernel/1201.2/02849.html
> http://lkml.indiana.edu/hypermail/linux/kernel/0912.1/00093.htm
> http://lkml.indiana.edu/hypermail/linux/kernel/0909.2/01661.html
> http://lkml.indiana.edu/hypermail/linux/kernel/0901.0/00772.html
> http://lkml.indiana.edu/hypermail/linux/kernel/0901.0/00148.html
> http://lkml.indiana.edu/hypermail/linux/kernel/0802.1/4393.html
>
> They've also been posted individually rather than as a series:
> http://lkml.indiana.edu/hypermail/linux/kernel/1101.2/00650.html
> http://lkml.indiana.edu/hypermail/linux/kernel/1101.2/00115.html
>
> Mentioned during related perl removal patches from other people:
> http://lkml.indiana.edu/hypermail/linux/kernel/0910.0/02145.html
>
> And so on. The most up to date version of these patches is always available at
> http://landley.net/hg/aboriginal in the sources/patches directory.
> Specifically, check:
>
> http://landley.net/hg/aboriginal/log/tip/sources/patches/linux-noperl-capflags.patch
> http://landley.net/hg/aboriginal/log/tip/sources/patches/linux-noperl-headers.patch
> http://landley.net/hg/aboriginal/log/tip/sources/patches/linux-noperl-timeconst.patch
>
> (Earlier versions had the kernel version number in the filename, so you'll have
> to dig in the repository a bit to find them if you want the version for an
> older kernel.)
>
> Mostly people just copy the patches into their local projects (ala
> https://github.com/rofl0r/sabotage/tree/master/KEEP ) but I'm reposting
> them to linux-kernel after Gentoo considered using these patches, but didn't
> because they weren't upstream:
>   https://bugs.gentoo.org/show_bug.cgi?id=421483
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
