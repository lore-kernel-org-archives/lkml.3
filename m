Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab3FCEz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 00:55:57 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:65062 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3FCEzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 00:55:51 -0400
MIME-Version: 1.0
In-Reply-To: <1370015432-17259-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1370015432-17259-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1370015432-17259-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Mon, 3 Jun 2013 10:25:50 +0530
Message-ID: <CAKohpomwHMP=0hxkv4rLRWty28h6F408wmPq6FU_vixL1X-krA@mail.gmail.com>
Subject: Re: [RFC PATCH v0 1/2] dma: move dw_dmac driver to an own directory
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 May 2013 21:20, Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
> +obj-$(CONFIG_DW_DMAC) += dw/

> +++ b/drivers/dma/dw/Makefile
> +obj-$(CONFIG_DW_DMAC) += dw_dmac.o

The lower one should be obj-y += dw_dmac.o as this will always
be true.
