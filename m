Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab3APOH1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 09:07:27 -0500
Received: from mail-vb0-f41.google.com ([209.85.212.41]:38118 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab3APOH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 09:07:26 -0500
MIME-Version: 1.0
In-Reply-To: <1358344131-18097-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1358344131-18097-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1358344131-18097-2-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Wed, 16 Jan 2013 19:37:25 +0530
X-Google-Sender-Auth: YvE6JnPbMbmXkn3mReJR17bimKg
Message-ID: <CAOh2x=nChhB3Bo7CnEZm_86OPBootPd5CqRZ8LCgS5RC4KhMWg@mail.gmail.com>
Subject: Re: [PATCH v3] dw_dmac: don't exceed AHB master number in dwc_get_data_width
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 7:18 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> +static inline unsigned int dwc_get_master(struct dma_chan *chan, int master)
> +{
> +       struct dw_dma *dw = to_dw_dma(chan->device);
> +       struct dw_dma_slave *dws = chan->private;
> +       unsigned int m = 0;

:(
