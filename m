Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaJFGkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 02:40:41 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:39177 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaJFGkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 02:40:40 -0400
Date: Sun, 5 Oct 2014 23:40:30 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 8/9] mtd: nand: stm_nand_bch: add support for ST's BCH
 NAND controller
Message-ID: <20141006064030.GA20598@norris-Latitude-E6410>
References: <1409143344-22458-1-git-send-email-lee.jones@linaro.org>
 <1409143344-22458-9-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409143344-22458-9-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 01:42:23PM +0100, Lee Jones wrote:
> Reviewed-By: Pekon Gupta <pekon@pek-sem.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mtd/nand/Kconfig        |    7 +
>  drivers/mtd/nand/Makefile       |    1 +
>  drivers/mtd/nand/stm_nand_bch.c | 1616 +++++++++++++++++++++++++++++++++++++++
>  drivers/mtd/nand/stm_nand_dt.c  |  110 +++
>  drivers/mtd/nand/stm_nand_dt.h  |   24 +
>  include/linux/mtd/stm_nand.h    |  147 ++++
>  6 files changed, 1905 insertions(+)
>  create mode 100644 drivers/mtd/nand/stm_nand_bch.c
>  create mode 100644 drivers/mtd/nand/stm_nand_dt.c
>  create mode 100644 drivers/mtd/nand/stm_nand_dt.h
>  create mode 100644 include/linux/mtd/stm_nand.h

One more thing: you never answered my question from [1]: 

Does your driver pass the MTD tests? (drivers/mtd/tests/)

Brian

[1] http://lists.infradead.org/pipermail/linux-mtd/2014-August/055084.html
