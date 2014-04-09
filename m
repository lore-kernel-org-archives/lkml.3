Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbaDIGBF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 02:01:05 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:47221 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaDIGBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 02:01:04 -0400
Date: Tue, 8 Apr 2014 23:00:59 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-mtd@lists.infradead.org, angus.clark@st.com
Subject: Re: [PATCH 07/15] mtd: st_spi_fsm: Extend fsm_clear_fifo to handle
 unwanted bytes
Message-ID: <20140409060059.GD3131@norris-Latitude-E6410>
References: <1395851969-13520-1-git-send-email-lee.jones@linaro.org>
 <1395851969-13520-8-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395851969-13520-8-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 04:39:21PM +0000, Lee Jones wrote:
> From: Angus Clark <angus.clark@st.com>
...
> diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
> index 8c56b94..9df59e7 100644
> --- a/drivers/mtd/devices/st_spi_fsm.c
> +++ b/drivers/mtd/devices/st_spi_fsm.c
...
> +	dev_dbg(fsm->dev, "cleared %d byte(s) from the data FIFO\n", 4 - i);
> +}
> +
>  static int stfsm_write_fifo(struct stfsm *fsm, uint32_t *buf, uint32_t size)

This patch does not apply to l2-mtd.git, and neither do several of the
following patches. You probably didn't rebase onto the patches regarding
the above line (adding 'const').

>  {
>  	uint32_t words = size >> 2;

Brian
