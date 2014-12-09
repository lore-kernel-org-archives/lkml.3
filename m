Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbaLIJFu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 04:05:50 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:50382 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbaLIJFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 04:05:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ley Foon Tan <lftan@altera.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lftan.linux@gmail.com
Subject: Re: [GIT PULL] arch/nios2 for v3.19
Date: Tue, 09 Dec 2014 10:05:43 +0100
Message-ID: <2956564.Rk8U9iLBaJ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418114172.4779.22.camel@leyfoon-vm>
References: <1418114172.4779.22.camel@leyfoon-vm>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:KNMoGDQXiV21927tgawf7Zl+cwSOMWXGBZKCCftnaPcLp7EMqm7
 XvXCGa7nV0erMKLJLkCZ6bZ3pBkjPNtOI1VZbjjokzQcbUMnwUBA4pDotCjb0NAeZdmAv8/
 v9hAHLIRFckiSFgIfRzKGOsrrPhbprhv8T7TuDKnXAjWotWMIJkfLr1OUDBnI+zGMUxsoOo
 m5oOvbeHPLTzaUIpfoowQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 December 2014 16:36:12 Ley Foon Tan wrote:
> Hi Linus
> 
> Here is the Linux port for Nios II processor (from Altera) arch/nios2/
> tree for v3.19. The patchset has been discussed on the kernel
> mailing lists since April and has gone through 6 revisions of review.
> The additional changes since then have been mostly further cleanups and
> fixes when merged with other trees.
> 
> The arch code is in arch/nios2 and one asm-generic change (acked by
> Arnd).
> 
> Please consider pulling. 
> 

For the pull request:

Acked-by: Arnd Bergmann <arnd@arndb.de>

I've reviewed the architecture port in the past and it looks good in
its latest version.

	Arnd
