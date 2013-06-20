Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965221Ab3FTImJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:42:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56327 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965010Ab3FTImE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:42:04 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: RE: [PATCH v3 0/4] MFD: Palmas: Add TPS659038 PMIC support on Palmas
Thread-Topic: [PATCH v3 0/4] MFD: Palmas: Add TPS659038 PMIC support on
 Palmas
Thread-Index: AQHObLH+cgG0zjO7tESS+pqHWYL5Zpk9w8eAgACGS2A=
Date: Thu, 20 Jun 2013 08:41:39 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229ECD8E@DBDE04.ent.ti.com>
References: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
 <20130620083913.GC15667@zurbaran>
In-Reply-To: <20130620083913.GC15667@zurbaran>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

> -----Original Message-----
> From: Samuel Ortiz [mailto:sameo@linux.intel.com]
> Sent: Thursday, June 20, 2013 2:09 PM
> To: J, KEERTHY
> Cc: linux-omap@vger.kernel.org; broonie@kernel.org;
> ldewangan@nvidia.com; grant.likely@secretlab.ca; swarren@nvidia.com;
> linux-kernel@vger.kernel.org; linux-doc@vger.kernel.org; devicetree-
> discuss@lists.ozlabs.org; gg@slimlogic.co.uk
> Subject: Re: [PATCH v3 0/4] MFD: Palmas: Add TPS659038 PMIC support on
> Palmas
> 
> Hi,
> 
> On Wed, Jun 19, 2013 at 11:27:46AM +0530, Keerthy wrote:
> > From: J Keerthy <j-keerthy@ti.com>
> >
> > The Patch series adds TPS659038 PMIC support in the palmas MFD and
> > Regulator drivers. The TPS659038 has almost the same registers as of
> > the earlier supported variants of PALMAS family such as the TWL6035.
> >
> > The critical differences between TPS659038 and TWL6035 being:
> >
> > 1) TPS659038 has nothing related to battery charging and back up
> battery stuff.
> > 2) TPS659038 does not have does not have SMPS10(Boost) step up
> convertor.
> > 3) TPS659038 does not have Battery detection and anything related to
> battery.
> > 4) SD card detection, Battery presence detection, Vibrator, USB OTG
> are missing
> >    when compared to TWL6035.
> >
> > The patch series is based on the patch:
> >
> > http://www.mail-archive.com/linux-omap@vger.kernel.org/msg90598.html
> >
> > V3:
> >
> > Implements Interrupts check using i2c->irq variable instead of DT
> > "interrupts" property.
> >
> > Cleans ups in assiging the features variable in patch 2.
> >
> > V2:
> >
> > Implements Interrupts checking via DT instead of creating flags and
> > checking based on chip ID.
> >
> > J Keerthy (4):
> >   MFD: Palmas: Check if irq is valid
> >   MFD: Palmas: Add SMPS10_BOOST feature
> >   mfd: Palmas: Add TPS659038 PMIC support
> >   regulator: Palmas: Add TPS659038 support
> I took the first 2 patches, but patch #3 does not apply.
> 

Thanks. I will split 3 and 4 separating Documentation files.
The Documentation was taken by Grant. So I will split the
Patches 3 and 4 and send a separate series. Thanks again for pulling
1 and 2.

> Cheers,
> Samuel.
> 
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/

Regards,
Keerthy
