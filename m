Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab3CWGza (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 02:55:30 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:47303 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab3CWGz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 02:55:29 -0400
MIME-Version: 1.0
In-Reply-To: <1363963401-7924-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1363963401-7924-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1363963401-7924-5-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Sat, 23 Mar 2013 12:25:28 +0530
Message-ID: <CAKohpo=ebMW97YhxFT+MpQtJF9M4pa8KNqpLWiDCuQtFPD+LnQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] dmaengine: dw_dmac: simplify master selection
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 March 2013 20:13, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> The patch to add the common DMA binding added a dummy dw_dma_slave
> structure into the dw_dma_chan structure in order to configure the
> masters correctly. It turns out that this can be simplified if we
> pick the DMA masters in the dwc_alloc_chan_resources function instead
> and save them in the dw_dma_chan structure directly.
>
> This could be simplified further once all users that today use
> dw_dma_slave for configuration get converted to device tree based
> setup instead.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  drivers/dma/dw_dmac.c      | 76 ++++++++++++++++++----------------------------
>  drivers/dma/dw_dmac_regs.h |  5 ++-
>  2 files changed, 33 insertions(+), 48 deletions(-)

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
