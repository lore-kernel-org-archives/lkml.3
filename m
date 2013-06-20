Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965179Ab3FTJNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:13:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58143 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965135Ab3FTJNb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:13:31 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: "broonie@kernel.org" <broonie@kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH v3 2/4] MFD: Palmas: Add SMPS10_BOOST feature
Thread-Topic: [PATCH v3 2/4] MFD: Palmas: Add SMPS10_BOOST feature
Thread-Index: AQHObLILjlLW/j6cEU6iDfHBoqLR45k+BUNQ///GdICAAIby8A==
Date: Thu, 20 Jun 2013 09:13:06 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229ECDCE@DBDE04.ent.ti.com>
References: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
 <1371621470-22279-3-git-send-email-j-keerthy@ti.com>
 <DC88CAD03C0052499C1907B327FC63229ECC05@DBDE04.ent.ti.com>
 <20130620090737.GF15667@zurbaran>
In-Reply-To: <20130620090737.GF15667@zurbaran>
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
> Sent: Thursday, June 20, 2013 2:38 PM
> To: J, KEERTHY
> Cc: broonie@kernel.org; ldewangan@nvidia.com;
> grant.likely@secretlab.ca; swarren@nvidia.com; linux-
> kernel@vger.kernel.org; linux-doc@vger.kernel.org; devicetree-
> discuss@lists.ozlabs.org; gg@slimlogic.co.uk; linux-
> omap@vger.kernel.org
> Subject: Re: [PATCH v3 2/4] MFD: Palmas: Add SMPS10_BOOST feature
> 
> Hi,
> 
> On Thu, Jun 20, 2013 at 04:34:42AM +0000, J, KEERTHY wrote:
> > > -----Original Message-----
> > > From: J, KEERTHY
> > > Sent: Wednesday, June 19, 2013 11:28 AM
> > > To: linux-omap@vger.kernel.org
> > > Cc: broonie@kernel.org; J, KEERTHY; ldewangan@nvidia.com;
> > > sameo@linux.intel.com; grant.likely@secretlab.ca;
> > > swarren@nvidia.com; linux-kernel@vger.kernel.org;
> > > linux-doc@vger.kernel.org; devicetree- discuss@lists.ozlabs.org;
> > > gg@slimlogic.co.uk
> > > Subject: [PATCH v3 2/4] MFD: Palmas: Add SMPS10_BOOST feature
> > >
> > > From: J Keerthy <j-keerthy@ti.com>
> > >
> > > The SMPS10 regulator is not presesnt in all the variants of the
> > > PALMAS PMIC family. Hence adding a feature to distingush between
> them.
> > >
> >
> > Could you please pull this patch?
> I'm reverting this one for now as of_match_device is not define for
> !CONFIG_OF.

So the of_match_device parts can come under #ifdef CONFIG_OF?

> 
> Cheers,
> Samuel.
> 
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/

Regards,
Keerthy
