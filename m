Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab3EFHP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 03:15:27 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:54511 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753107Ab3EFHPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 03:15:23 -0400
Date: Mon, 6 May 2013 12:43:56 +0530
From: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 54/63] ARM: ux500: Replace ST-E's home-brew DMA
 direction definition with the generic one
Message-ID: <20130506071355.GA5552@bnru10>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
 <1367591569-32197-55-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1367591569-32197-55-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 16:32:40 +0200, Lee Jones wrote:
> STEDMA40_*_TO_* direction definitions are identical in all but name to
> the pre-defined generic DMA_*_TO_* ones. Let's make things easy by not
> duplicating such things.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/mach-ux500/board-mop500-audio.c |   12 ++++++------
>  arch/arm/mach-ux500/board-mop500-sdi.c   |   16 ++++++++--------
>  arch/arm/mach-ux500/board-mop500.c       |   22 +++++++++++-----------
>  arch/arm/mach-ux500/usb.c                |    4 ++--
>  4 files changed, 27 insertions(+), 27 deletions(-)

Hope you have taken care for all other files, because, I see
few more instances in my tree apart from the above files.

Otherwise..

Acked-by: srinidhi kasagar <srinidhi.kasagar@stericsson.com>

regards,
srinidhi
