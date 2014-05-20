Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaETQLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 12:11:39 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:62419 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbaETQLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 12:11:37 -0400
Date: Tue, 20 May 2014 17:11:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Matt Porter <mporter@linaro.org>
Cc: Devicetree List <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/4] mfd: bcm590xx: add support for secondary I2C
 slave address
Message-ID: <20140520161131.GB32025@lee--X1>
References: <1398295293-11033-1-git-send-email-mporter@linaro.org>
 <1398295293-11033-3-git-send-email-mporter@linaro.org>
 <20140428115627.GY21279@lee--X1>
 <20140428140910.GB7719@beef>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140428140910.GB7719@beef>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > BCM590xx utilizes a secondary I2C slave address to access additional
> > > register space. Add support for the secondary address space by
> > > instantiating a dummy I2C device with the appropriate secondary
> > > I2C slave address. Also expose a secondary regmap register space so
> > > that MFD drivers can access this secondary i2c slave address space.
> > > 
> > > Signed-off-by: Matt Porter <mporter@linaro.org>
> > > ---
> > >  drivers/mfd/bcm590xx.c       | 60 +++++++++++++++++++++++++++++++++-----------
> > >  include/linux/mfd/bcm590xx.h |  9 ++++---
> > >  2 files changed, 52 insertions(+), 17 deletions(-)
> > 
> > Nice, flows much better now.
> > 
> > Can I just apply the two MFD patches, or are there cross-deps?
> 
> There's cross-deps so the regulator driver will need to go with it.
> Mark mentioned earlier in the thread that he wanted to merge through
> the regulator tree though.

Still nothing.

Mark,
  Can I apply this set and supply you with a pull-request?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
