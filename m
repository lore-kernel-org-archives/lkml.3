Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726Ab3ENJyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 05:54:06 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:38476 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab3ENJyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 05:54:04 -0400
Date: Tue, 14 May 2013 10:54:02 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Mark Brown <broonie@kernel.org>, myungjoo.ham@samsung.com,
        cw00.choi@samsung.com, balbi@ti.com, ldewangan@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, ruchika@ti.com,
        tony@atomide.com, sameo@linux.intel.com
Subject: Re: [PATCH v4] extcon: Palmas Extcon Driver
Message-ID: <20130514095402.GA9721@xora-build.xora.org.uk>
References: <1362662506-14823-4-git-send-email-kishon@ti.com>
 <1367846225-15685-1-git-send-email-kishon@ti.com>
 <20130506144010.GF13472@opensource.wolfsonmicro.com>
 <51888D55.3090907@ti.com>
 <20130507075824.GM7478@sirena.org.uk>
 <5188CD9C.6010602@ti.com>
 <20130507104502.GQ7478@sirena.org.uk>
 <5192017D.6060108@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5192017D.6060108@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 02:48:53PM +0530, Kishon Vijay Abraham I wrote:
> On Tuesday 07 May 2013 04:15 PM, Mark Brown wrote:
> >On Tue, May 07, 2013 at 03:17:08PM +0530, Kishon Vijay Abraham I wrote:
> >>On Tuesday 07 May 2013 01:28 PM, Mark Brown wrote:
> >
> >>>>The platform can provide it's own vbus control in which case this is
> >>>>not needed.
> >
> >>>So why is there no interaction with this external VBUS control and how
> >>>does the driver distinguish between that and an error getting the
> >>>regulator?
> >
> >>The platform specifies if it provides its own VBUS control by the dt
> >>property ti,no_control_vbus. So the driver will give an error only
> >>when *ti,no_control_vbus* is not set. Graeme?
> >
> >That doesn't answer the question about why there's no interaction with
> >the external control...
> >
> 
> Graeme?
> 
I already partially answered this, it was written for a SoC where VBUS
generation was in hardware on the SoC with no information.

I would say if nvidia/Laxman do not need this remove it, if someone ever
uses it then they can re-add it easy enough!

Graeme

