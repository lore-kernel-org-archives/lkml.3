Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbbAZJ4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 04:56:48 -0500
Received: from mx-guillaumet.finsecur.com ([91.217.234.131]:46903 "EHLO
	guillaumet.finsecur.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbbAZJ4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 04:56:00 -0500
Date: Mon, 26 Jan 2015 10:55:54 +0100
From: Sylvain Rochet <sylvain.rochet@finsecur.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: nicolas.ferre@atmel.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com, peda@axentia.se
Message-ID: <20150126095554.GA18807@gradator.net>
References: <1422265005-22937-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1422265005-22937-1-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 172.16.8.13
X-SA-Exim-Mail-From: sylvain.rochet@finsecur.com
Subject: Re: [PATCH v2 00/12] AT91 pm cleanup for 3.20
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on guillaumet.finsecur.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Wenyou,

On Mon, Jan 26, 2015 at 05:36:45PM +0800, Wenyou Yang wrote:
> Hi Nicolas,
> 
> This version is rebased on the branch: at91-3.20-cleanup of the repository
> 	git://git.kernel.org/pub/scm/linux/kernel/git/nferre/linux-at91.git
> 
> It is purpose to clean up the PM code, includes the patches from Peter Rosin and Sylvain Rochet.
> 
> Since verifying the USB clock and USB PLL disabling before suspending to memory,
> it aslo depends on the following patch serials from Sylvain:
> 	[PATCHv6 0/5] USB: gadget: atmel_usba_udc: Driver improvements
> 	[PATCHv7 0/6] USB: host: Atmel OHCI and EHCI drivers improvements
> 
> Removes CONFIG_AT91_SLOW_CLOCK config item to simply the PM config,
> The suspend to standby mode uses the same sram function as the suspend to memory mode.
> Remove some unused code.
> 
> Alexandr & Sylvain, Thank you very much for so many feedbacks.
> 
> Changes in v2:
>  - Rebase on the at91-3.20-cleanup branch
>  - Recover the verify clock condition, only for suspend to memory.
>  - Collect ACK from Alexandre
>  - Add the macro for PM mode

Did you fix the slow_clock == NULL condition with the change suggested 
by Alexandre ?

Sylvain
