Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaBJOYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:24:43 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:44973 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbaBJOYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:24:41 -0500
Date: Mon, 10 Feb 2014 14:24:35 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 13/15] regulator/mfd: max14577: Export symbols for
 calculating charger current
Message-ID: <20140210142435.GC23141@lee--X1>
References: <1391767487-10017-1-git-send-email-k.kozlowski@samsung.com>
 <1391767487-10017-14-git-send-email-k.kozlowski@samsung.com>
 <20140210115928.GF22773@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140210115928.GF22773@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This patch prepares for changing the max14577 charger driver to allow
> > configuring battery-dependent settings from DTS.
> > 
> > The patch moves from regulator driver to MFD core driver and exports:
> >  - function for calculating register value for charger's current;
> >  - table of limits for chargers (MAX14577, MAX77836).
> > 
> > Previously they were used only by the max14577 regulator driver. In next
> > patch the charger driver will use them as well. Exporting them will
> > reduce unnecessary code duplication.
> > 
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  drivers/mfd/max14577.c               |   95 ++++++++++++++++++++++++++++++++++
> >  drivers/regulator/max14577.c         |   80 +++-------------------------
> >  include/linux/mfd/max14577-private.h |   22 ++++----
> >  include/linux/mfd/max14577.h         |   23 ++++++++
> >  4 files changed, 135 insertions(+), 85 deletions(-)
> 
> Applied, with Mark's Ack.

Whoops, jumping the gun there. We're still waiting on Acks aren't we.

Instead:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
