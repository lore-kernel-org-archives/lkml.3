Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaKPXMo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 18:12:44 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:62876 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaKPXMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 18:12:43 -0500
Date: Sun, 16 Nov 2014 15:12:44 -0800
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: fixes for 3.18 #2
Message-ID: <20141116231244.GD14929@quad.lixom.net>
References: <1415963482-16582-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415963482-16582-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 12:11:22PM +0100, Nicolas Ferre wrote:
> Arnd, Olof, Kevin,
> 
> I don't have more for the moment, so here is trivial at91 material for 3.18.
> 
> Thanks, best regards,
> 
> The following changes since commit 106c67af2fb938880edbf43b49dabbd8d2534839:
> 
>   ARM: at91/dt: sam9263: fix PLLB frequencies (2014-10-22 10:08:22 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git tags/at91-fixes2
> 
> for you to fetch changes up to c4e4bbcee9fa37024a2d4cdcaa5fe89a2c5c7a05:
> 
>   ARM: at91/dt: Fix sama5d3x typos (2014-11-13 12:37:44 +0100)
> 
> ----------------------------------------------------------------
> Tiny typo fixes for this second batch for 3.18
> 
> ----------------------------------------------------------------
> Ludovic Desroches (1):
>       ARM: at91/dt: sama5d4: use macro instead of numeric value

I don't consider this to be a fix at this time in the release, please
include in your 3.19 material.

> Peter Rosin (1):
>       ARM: at91/dt: Fix sama5d3x typos
> 

I did cherry-pick this one in though.

Not sure if I'll make today's -rc with my fixes pull request. :)


-Olof
