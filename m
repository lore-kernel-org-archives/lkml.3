Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819AbaLCU1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:27:23 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:62878 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbaLCU1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:27:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>, linux-samsung-soc@vger.kernel.org,
        lauraa@codeaurora.org, tony@atomide.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        loeliger@gmail.com, Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        linux-omap@vger.kernel.org, drake@endlessm.com
Subject: Re: [PATCH v9 0/7] Enable L2 cache support on Exynos4210/4x12 SoCs
Date: Wed, 03 Dec 2014 21:26:39 +0100
Message-ID: <10964164.OYZFDUglOR@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141203160332.GA11502@n2100.arm.linux.org.uk>
References: <1416224909-4290-1-git-send-email-m.szyprowski@samsung.com> <3059840.P4aX5Il9dy@wuerfel> <20141203160332.GA11502@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:V9ef3PE2deEDscdCqFzJPrEUozz7Zf8lvhna2NYjn10
 LMR4a34ysCFtKWpgkBzmzQToUUK6RpY+602lctNNzhOa+XROvc
 yh5KrLjoG8LG273o98uNO3jUxosgywUzVPnjCHhOm2WCsyeZAP
 SBrQPtiHFmVTrZY6dfzB3jt+L1/643/lXvkxS6/ehqfd5+d0h+
 2cQByAuMsNNPT0+xxASLgWoJFzF7niAbNJEjtpZSO0C4cSDRzu
 +nQYl1I/C/Zjkdn8cH3Wzy69KRWb9/HUPOXq3mgrZg9dE3LKOs
 zjFJvbPwtT1m2K21cBWpKBwjuEF1s1ckDv6feID23Dqq/nZdLZ
 N0dme5Lc22b11eja9IGQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 16:03:32 Russell King - ARM Linux wrote:
> On Fri, Nov 28, 2014 at 12:11:38PM +0100, Arnd Bergmann wrote:
> > I'm fine with it either way. Russell, if you like you can merge
> > http://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung v3.19-next/pm-samsung-2
> 
> It'd be nicer to have a git URL for it.

git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung v3.19-next/pm-samsung-2

I don't see much difference between the two, but I never cared to look
into the protocol details. The one I listed first was the URL I got from
Kukjin, and git could access that.

	Arnd
