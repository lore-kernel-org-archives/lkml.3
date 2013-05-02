Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab3EBKy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 06:54:59 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39756 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223Ab3EBKy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 06:54:58 -0400
Date: Thu, 2 May 2013 11:54:53 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 0/6] dmaengine: Refactor the DMA40 driver - continued
Message-ID: <20130502105453.GL25256@gmail.com>
References: <1366976295-11728-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1366976295-11728-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013, Lee Jones wrote:

> This is a continuation of the first "dmaengine: Refactor the DMA40 driver"
> patch-set. It encompasses some recommendations given during the review of
> it's predecessor.
> 
>  arch/arm/mach-ux500/board-mop500-audio.c    |   12 +++++-----
>  arch/arm/mach-ux500/board-mop500-sdi.c      |   16 ++++++-------
>  arch/arm/mach-ux500/board-mop500.c          |   22 ++++++++---------
>  arch/arm/mach-ux500/usb.c                   |    4 ++--
>  drivers/dma/ste_dma40.c                     |   99 +++++++++++++++++++++++++++++++++-------------------------------------------
>  drivers/dma/ste_dma40_ll.c                  |  122 ++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------
>  include/linux/platform_data/dma-ste-dma40.h |   19 ++-------------
>  sound/soc/ux500/ux500_pcm.c                 |   10 ++++----
>  8 files changed, 147 insertions(+), 157 deletions(-)
> 

Linus, poke for this series.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
