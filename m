Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbaHRKGo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:06:44 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:63080 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbaHRKGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 06:06:42 -0400
Date: Mon, 18 Aug 2014 11:06:36 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 0/8] mtd: nand: Support for new DT NAND driver
Message-ID: <20140818100636.GB4266@lee--X1>
References: <1407921127-8590-1-git-send-email-lee.jones@linaro.org>
 <20140814224013.GE18411@ld-irv-0074>
 <20140818083953.GA4266@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140818083953.GA4266@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Particularly, take a hard look at rewriting
> > include/linux/mtd/stm_nand_bbt.h.
> 
> I don't think there is any need - although this change is required:
> 
> -#if defined(MTD_NAND_STM_BBT)
> +#if defined(MTD_NAND_STM_BCH_BBT)

Sorry, I mean this:

-#if defined(MTD_NAND_STM_BBT)
+#if defined(CONFIG_MTD_NAND_STM_BCH_BBT)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
