Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbaDPMSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 08:18:22 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:63029 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbaDPMSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 08:18:20 -0400
Date: Wed, 16 Apr 2014 13:18:14 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v5 0/9] mfd: max14577: Add support for MAX77836
Message-ID: <20140416121814.GD19671@lee--X1>
References: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
 <20140416102846.GL4754@lee--X1>
 <1397645078.6147.11.camel@AMDC1943>
 <20140416110806.GB19671@lee--X1>
 <1397646784.6147.18.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397646784.6147.18.camel@AMDC1943>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > This is first part of fifth version of patchset adding support for
> > > > > MAX77836 device to the max14577 driver.
> > > > > 
> > > > > I decided to split the patchset into smaller parts. I hope this would
> > > > > help in getting necessary review/acks from maintainers.
> > > > > 
> > > > > The first part introduces changes in max14577 driver and adds support
> > > > > for MAX77836 in MFD, extcon and regulator drivers. Most of these
> > > > > patches already have required acks from maintainers.
> > > > > Full v4 patchset can be found here:
> > > > > http://thread.gmane.org/gmane.linux.kernel/1654267
> > > > 
> > > > So what's the plan for this driver now? What's missing? Do you have
> > > > all the Acks you need? If so, I'm happy to apply this patch-set and
> > > > supply a pull-request to the other maintainers.
> > > 
> > > Next patches (part 2):
> > > 1. charger: max14577: Add support for MAX77836 charger
> > > 2. power: max17040: Add ID for MAX77836 Fuel Gauge block
> > > 3. regulator/mfd: max14577: Export symbols for calculating charger 
> > >    current
> > > 4. charger: max14577: Configure battery-dependent settings from DTS
> > > 5. Documentation: mfd: max14577: Add device tree bindings document
> > > 6. regulator: max14577: Implement SUSPEND mode for MAX77836 LDO-s
> > > 
> > > They are quite independent from each other so I think it would be the
> > > best if you could prepare an immutable branch with first part of
> > > patches.
> > 
> > I'm only concerned with the patches in this set at the moment.
> > 
> > Do all of the patches in _this_ set have all of the required Acks, or
> > are you still waiting on some maintainers?
> 
> I have all necessary Acks for this patchset.
> One exception: patch 9/9 (regulator) was only reviewed by Mark Brown,
> not acked:
> https://lkml.org/lkml/2014/1/28/252

That's okay. Still counts. :)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
