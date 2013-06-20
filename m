Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab3FTJHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:07:49 -0400
Received: from mga11.intel.com ([192.55.52.93]:13110 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182Ab3FTJHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:07:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,903,1363158000"; 
   d="scan'208";a="356621418"
Date: Thu, 20 Jun 2013 11:07:37 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: "J, KEERTHY" <j-keerthy@ti.com>
Cc: "broonie@kernel.org" <broonie@kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v3 2/4] MFD: Palmas: Add SMPS10_BOOST feature
Message-ID: <20130620090737.GF15667@zurbaran>
References: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
 <1371621470-22279-3-git-send-email-j-keerthy@ti.com>
 <DC88CAD03C0052499C1907B327FC63229ECC05@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DC88CAD03C0052499C1907B327FC63229ECC05@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jun 20, 2013 at 04:34:42AM +0000, J, KEERTHY wrote:
> > -----Original Message-----
> > From: J, KEERTHY
> > Sent: Wednesday, June 19, 2013 11:28 AM
> > To: linux-omap@vger.kernel.org
> > Cc: broonie@kernel.org; J, KEERTHY; ldewangan@nvidia.com;
> > sameo@linux.intel.com; grant.likely@secretlab.ca; swarren@nvidia.com;
> > linux-kernel@vger.kernel.org; linux-doc@vger.kernel.org; devicetree-
> > discuss@lists.ozlabs.org; gg@slimlogic.co.uk
> > Subject: [PATCH v3 2/4] MFD: Palmas: Add SMPS10_BOOST feature
> > 
> > From: J Keerthy <j-keerthy@ti.com>
> > 
> > The SMPS10 regulator is not presesnt in all the variants of the PALMAS
> > PMIC family. Hence adding a feature to distingush between them.
> > 
> 
> Could you please pull this patch?
I'm reverting this one for now as of_match_device is not define for
!CONFIG_OF.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
