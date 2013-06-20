Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab3FTEUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 00:20:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39081 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab3FTEUV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 00:20:21 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: RE: [PATCH v3 1/4] MFD: Palmas: Check if irq is valid
Thread-Topic: [PATCH v3 1/4] MFD: Palmas: Check if irq is valid
Thread-Index: AQHObLIGtU4PkvUD5U+jS6p5a9n8zZk8v9mAgAFBjoA=
Date: Thu, 20 Jun 2013 04:19:59 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229ECBD7@DBDE04.ent.ti.com>
References: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
 <1371621470-22279-2-git-send-email-j-keerthy@ti.com>
 <51C1E5A5.9090105@wwwdotorg.org>
In-Reply-To: <51C1E5A5.9090105@wwwdotorg.org>
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
> From: Stephen Warren [mailto:swarren@wwwdotorg.org]
> Sent: Wednesday, June 19, 2013 10:39 PM
> To: J, KEERTHY
> Cc: linux-omap@vger.kernel.org; broonie@kernel.org;
> ldewangan@nvidia.com; sameo@linux.intel.com; grant.likely@secretlab.ca;
> swarren@nvidia.com; linux-kernel@vger.kernel.org; linux-
> doc@vger.kernel.org; devicetree-discuss@lists.ozlabs.org;
> gg@slimlogic.co.uk
> Subject: Re: [PATCH v3 1/4] MFD: Palmas: Check if irq is valid
> 
> On 06/18/2013 11:57 PM, Keerthy wrote:
> > From: J Keerthy <j-keerthy@ti.com>
> >
> > Check if irq value obtained is valid. If it is not valid then skip
> the
> > irq request step and go ahead with the probe.
> 
> Reviewed-by: Stephen Warren <swarren@nvidia.com>

Thanks Stephen.
