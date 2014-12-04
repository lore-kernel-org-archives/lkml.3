Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbaLDSKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:10:36 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:58472 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbaLDSKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:10:33 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: defconfig for 3.19 #1 (bis)
Date: Thu, 04 Dec 2014 19:10:16 +0100
Message-ID: <5326460.tA0RksQ2IP@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417711082-27680-1-git-send-email-nicolas.ferre@atmel.com>
References: <3905790.gg6cCb9BU6@wuerfel> <1417711082-27680-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:NKW71oWlwJWEfex1CofiUj0iP7Vguqdag+rK687z6qEvSQpjn9T
 Wj1DZ8ombevH5A65/qwJenKFdeC+2EDdPfIoHzuZ/wl7LdJYLLUJOxfOatPwE/FQHdg7zro
 A0wIseMl2fswlUupUvnyrMN2vRAcT9eJ/mHOTEwG7ZJH+AEpJOmSFTGz6vMZ5KFN4+XlXb8
 FA1RNQfZPXMWOI87TYxwQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2014 17:38:02 Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> This is the updated version of the 3.19 defconfig pull-request. It is now based
> on 3.18-rc1 per Arnd's request.
> 
> Here is a pull-request for updating the AT91 defconfig files. Note that we only
> have two now that the per-SoC defconfigs are gone.
> 
> Thanks, bye,
> 
> The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:
> 
>   Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-defconfig
> 
> for you to fetch changes up to 51756cbd407b760858a16341eb37ee527be178fd:
> 
>   ARM: at91/defconfig: add DM9000 to at91_dt (2014-12-04 17:32:01 +0100)
> 
> ----------------------------------------------------------------
> First batch of defconfigs for AT91 / 3.19:
> - use NEON for all C-A5, neon code handles the !NEON case
> - add new XDMA driver
> - add some useful drivers as we only have a single defconfig for all
>   AT91SAM9/RM9200
> 

Pulled into next/defconfig, thanks!

	Arnd
