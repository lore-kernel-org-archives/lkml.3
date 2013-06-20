Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965277Ab3FTJ1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:27:19 -0400
Received: from mga11.intel.com ([192.55.52.93]:30968 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965226Ab3FTJ1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:27:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,903,1363158000"; 
   d="scan'208";a="356631396"
Date: Thu, 20 Jun 2013 11:27:12 +0200
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
Message-ID: <20130620092712.GG15667@zurbaran>
References: <1371621470-22279-1-git-send-email-j-keerthy@ti.com>
 <1371621470-22279-3-git-send-email-j-keerthy@ti.com>
 <DC88CAD03C0052499C1907B327FC63229ECC05@DBDE04.ent.ti.com>
 <20130620090737.GF15667@zurbaran>
 <DC88CAD03C0052499C1907B327FC63229ECDCE@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DC88CAD03C0052499C1907B327FC63229ECDCE@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 09:13:06AM +0000, J, KEERTHY wrote:
> > > Could you please pull this patch?
> > I'm reverting this one for now as of_match_device is not define for
> > !CONFIG_OF.
> 
> So the of_match_device parts can come under #ifdef CONFIG_OF?
Nevermind, you were "just" missing an of_device.h inclusion. I fixed
that up and applied your patch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
