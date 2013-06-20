Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030375Ab3FTOLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:11:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42296 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030360Ab3FTOLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:11:33 -0400
From: "Cousson, Benoit" <b-cousson@ti.com>
To: "Quadros, Roger" <rogerq@ti.com>
CC: "tony@atomide.com" <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 0/2] ARM: dts: Add USB host support for Beagle-xm
Thread-Topic: [PATCH v5 0/2] ARM: dts: Add USB host support for Beagle-xm
Thread-Index: AQHObbQpc1IUVewzIES5AteXfA54X5k+pCnQ
Date: Thu, 20 Jun 2013 14:11:04 +0000
Message-ID: <B7CE1C39EBFBA0428A012975D4B2FC830B72CECA@DNCE05.ent.ti.com>
References: <1371732374-27191-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1371732374-27191-1-git-send-email-rogerq@ti.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.167.131.83]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Roger,

I'll take them for 3.12. I was already late for my 3.11 pull request.

Regards,
Benoit

>
Texas Instruments France SA, 821 Avenue Jack Kilby, 06270 Villeneuve Loubet. 036 420 040 R.C.S Antibes. Capital de EUR 12.654.784

-----Original Message-----
>From: Quadros, Roger
>Sent: Thursday, June 20, 2013 7:46 AM
>To: Cousson, Benoit
>Cc: tony@atomide.com; linux-omap@vger.kernel.org; devicetree-
>discuss@lists.ozlabs.org; linux-arm-kernel@lists.infradead.org; linux-
>kernel@vger.kernel.org; Quadros, Roger
>Subject: [PATCH v5 0/2] ARM: dts: Add USB host support for Beagle-xm
>
>Hi Benoit,
>
>Patch 1 adds USB host support for beagle-XM.
>Patch 2 cleans up pin comments for USB host pins.
>
>Changes in v4:
>- Rebased to todays for_3.11/dts branch
>- added disclaimer about temporary usage of regulator framework for
>GPIO RESET lines.
>
>cheers,
>-roger
>
>Roger Quadros (2):
>  ARM: dts: omap3-beagle-xm: Add USB Host support
>  ARM: dts: omap3-beagle: Make USB host pin naming consistent
>
> arch/arm/boot/dts/omap3-beagle-xm.dts |   81
>+++++++++++++++++++++++++++++----
> arch/arm/boot/dts/omap3-beagle.dts    |   29 +++++++-----
> 2 files changed, 89 insertions(+), 21 deletions(-)
>
>--
>1.7.4.1


