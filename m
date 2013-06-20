Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965314Ab3FTJ3Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:29:24 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56083 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964817Ab3FTJ3T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:29:19 -0400
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
Thread-Index: AQHObLILjlLW/j6cEU6iDfHBoqLR45k+BUNQ///GdICAAIby8P//foYAgACGQkA=
Date: Thu, 20 Jun 2013 09:28:55 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229ECE00@DBDE04.ent.ti.com>
References: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
 <1371621470-22279-3-git-send-email-j-keerthy@ti.com>
 <DC88CAD03C0052499C1907B327FC63229ECC05@DBDE04.ent.ti.com>
 <20130620090737.GF15667@zurbaran>
 <DC88CAD03C0052499C1907B327FC63229ECDCE@DBDE04.ent.ti.com>
 <20130620092712.GG15667@zurbaran>
In-Reply-To: <20130620092712.GG15667@zurbaran>
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



> -----Original Message-----
> From: Samuel Ortiz [mailto:sameo@linux.intel.com]
> Sent: Thursday, June 20, 2013 2:57 PM
> To: J, KEERTHY
> Cc: broonie@kernel.org; ldewangan@nvidia.com;
> grant.likely@secretlab.ca; swarren@nvidia.com; linux-
> kernel@vger.kernel.org; linux-doc@vger.kernel.org; devicetree-
> discuss@lists.ozlabs.org; gg@slimlogic.co.uk; linux-
> omap@vger.kernel.org
> Subject: Re: [PATCH v3 2/4] MFD: Palmas: Add SMPS10_BOOST feature
> 
> On Thu, Jun 20, 2013 at 09:13:06AM +0000, J, KEERTHY wrote:
> > > > Could you please pull this patch?
> > > I'm reverting this one for now as of_match_device is not define for
> > > !CONFIG_OF.
> >
> > So the of_match_device parts can come under #ifdef CONFIG_OF?
> Nevermind, you were "just" missing an of_device.h inclusion. I fixed
> that up and applied your patch.

Oops..I get it. Thanks.

> 
> Cheers,
> Samuel.
> 
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
