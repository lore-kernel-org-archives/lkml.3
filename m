Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaCLJYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 05:24:05 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:55387 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbaCLJYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 05:24:02 -0400
Date: Wed, 12 Mar 2014 09:23:55 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Matt Porter <mporter@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/5] mfd: add bcm590xx pmu driver
Message-ID: <20140312092355.GB5672@lee--X1>
References: <1394552775-31264-1-git-send-email-mporter@linaro.org>
 <1394552775-31264-3-git-send-email-mporter@linaro.org>
 <20140311160837.GP21216@lee--X1>
 <20140311221938.GO25092@beef>
 <20140311224517.GA5672@lee--X1>
 <20140311232545.GP25092@beef>
 <20140312004030.GH28112@sirena.org.uk>
 <20140312005748.GQ25092@beef>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140312005748.GQ25092@beef>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Are there any inter-patch dependencies in the set? If so, we should
> > > > know about them so we can coordinate a sensible solution.
> > 
> > > Yes, the regulator driver (3/5) that Mark applied is dependent on this
> > > patch...the regulator driver includes include/linux/mfd/bcm590xx.h.
> > 
> > There's no actual dependency though - the regulator driver can only be
> > built if the MFD is enabled in Kconfig since it depends on it so until
> > the MFD is present in the tree it won't get built.
> 
> Oh, right. Lee, no dependencies then.

Perfect, I'll just apply the MFD patch.

We still need the DT guys to look over your document, so nothing will
be certain until a) we receive their Ack or b) enough time passes, so
we will review it between ourselves.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
