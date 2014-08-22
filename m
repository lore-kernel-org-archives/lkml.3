Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaHVTJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:09:27 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:35391 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbaHVTJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:09:25 -0400
Date: Fri, 22 Aug 2014 20:09:20 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@linaro.org>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Subject: Re: linux-next: build failure after merge of the mfd tree
Message-ID: <20140822190920.GX4266@lee--X1>
References: <20140823025616.690f0c83@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140823025616.690f0c83@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Aug 2014, Stephen Rothwell wrote:

> Hi Lee,
> 
> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> ERROR: "wm8994_base_regmap_config" [drivers/mfd/wm8994-core.ko] undefined!
> ERROR: "wm8994_irq_init" [drivers/mfd/wm8994-core.ko] undefined!
> ERROR: "wm1811_regmap_config" [drivers/mfd/wm8994-core.ko] undefined!
> ERROR: "wm8958_regmap_config" [drivers/mfd/wm8994-core.ko] undefined!
> ERROR: "wm8994_regmap_config" [drivers/mfd/wm8994-core.ko] undefined!
> 
> Presumably caused by commit a3ee6a4e2729 ("mfd: wm8994: Allow modular
> build").
> 
> I have used the mfd tree from next-20140822 for today.

I fixed this at 10 o'clock this morning?

When did you pull?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
