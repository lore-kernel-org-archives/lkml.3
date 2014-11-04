Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaKDIIA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:08:00 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:56850 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaKDIH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:07:57 -0500
Date: Tue, 4 Nov 2014 08:07:50 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH v3 08/14] mfd: max77686/802: Remove support for board
 files
Message-ID: <20141104080750.GB17577@x1>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
 <1414668053-31370-9-git-send-email-k.kozlowski@samsung.com>
 <20141103170128.GD12011@x1>
 <1415087510.2389.4.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415087510.2389.4.camel@AMDC1943>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Nov 2014, Krzysztof Kozlowski wrote:

> On pon, 2014-11-03 at 17:01 +0000, Lee Jones wrote:
> > On Thu, 30 Oct 2014, Krzysztof Kozlowski wrote:
> > 
> > > The driver is used only on Exynos based boards with DTS support.
> > > Convert the driver to DTS-only version. This simplifies a little the
> > > code:
> > > 1. No dead (unused) entries in platform_data structure.
> > > 2. More code removed.
> > > 3. Regulator driver does not depend on allocated memory
> > >    from MFD driver.
> > > 4. It makes also easier extending the regulator driver.
> > > 
> > > Add to the max77686 MFD driver dependency on CONFIG_OF because without
> > > DTS the regulator drivers won't bind.
> > > 
> > > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > > Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> > > ---
> > >  drivers/mfd/Kconfig                  |  1 +
> > >  drivers/mfd/max77686.c               | 23 -----------------------
> > >  include/linux/mfd/max77686-private.h |  1 -
> > >  include/linux/mfd/max77686.h         | 28 ----------------------------
> > >  4 files changed, 1 insertion(+), 52 deletions(-)
> > 
> > Applied, thanks.
> 
> 
> Noooo, don't apply it. It depends on previous patches removing the board
> file support from regulators.
> 
> If the patch looks OK, please only ack it. I would like to push
> everything through regulator tree.

Very well, patch dropped.

As long as Mark puts it on a succinct tagged branch it can go in
through his tree:

Acked-by: Lee Jones <lee.jones@linaro.org>

Mark,
  Please send me the tag to pull from once applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
