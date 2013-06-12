Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab3FLJni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:43:38 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:56664 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab3FLJng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:43:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130612090202.GM4107@intel.com>
References: <20130612050829.GB4107@intel.com>
	<CAHp75Ver2xo2f9crQZkAmJcTF=5cZZa3NgvufPqQW3+uTXffJA@mail.gmail.com>
	<20130612073806.GG4107@intel.com>
	<CAHp75VfsSDdLa_uPULbhVGproxnD5mofYm62O75y4xRbPBJ7pQ@mail.gmail.com>
	<20130612075225.GI4107@intel.com>
	<CAHp75Vc=hO_FF0WMvhPm6MMRuCb+=MhOEOCSYb_TaCRf-xQ=sg@mail.gmail.com>
	<20130612081202.GK4107@intel.com>
	<CAKohpok8jyUF33hatMJzLwokHM2Ou=N8rHQ4oQ5xQ2AiSSN__w@mail.gmail.com>
	<20130612081917.GL4107@intel.com>
	<CAHp75VdKsMgdZcA72-eJZWV1cyc+Xkskrpr0i_QBMOZtV6tpeg@mail.gmail.com>
	<20130612090202.GM4107@intel.com>
Date: Wed, 12 Jun 2013 15:13:36 +0530
Message-ID: <CAKohpo=+KnsPXYj7jOLW50LxGfqWWvbt5BYRXVfRLnJCdAVjQQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] dma: move dw_dmac driver to an own directory
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>, Arnd Bergmann <arnd@arndb.de>,
        Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 June 2013 14:32, Vinod Koul <vinod.koul@intel.com> wrote:
> diff --git a/drivers/dma/dw/regs.h b/drivers/dma/dw/regs.h
> index 07c5a6e..deb4274 100644
> --- a/drivers/dma/dw/regs.h
> +++ b/drivers/dma/dw/regs.h
> @@ -101,6 +101,12 @@ struct dw_dma_regs {
>         u32     DW_PARAMS;
>  };
>
> +/*
> + * Big endian I/O access when reading and writing to the DMA controller
> + * registers.  This is needed on some platforms, like the Atmel AVR32
> + * architecture.
> + */
> +
>  #ifdef CONFIG_DW_DMAC_BIG_ENDIAN_IO
>  #define dma_readl_native ioread32be
>  #define dma_writel_native iowrite32be

Looks. Good.
