Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab3FJJzg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:55:36 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:47056 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667Ab3FJJzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:55:33 -0400
Date: Mon, 10 Jun 2013 10:55:28 +0100
From: Lee Jones <lee.jones@linaro.org>
To: "J, KEERTHY" <j-keerthy@ti.com>
Cc: "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "wim@iguana.be" <wim@iguana.be>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "Kristo, Tero" <t-kristo@ti.com>, Ian Lartey <ian@slimlogic.co.uk>
Subject: Re: [PATCH v3] mfd: DT bindings for the palmas family MFD
Message-ID: <20130610095528.GH20297@gmail.com>
References: <1370496441-24620-1-git-send-email-j-keerthy@ti.com>
 <20130606070210.GR3370@gmail.com>
 <20130606070610.GS3370@gmail.com>
 <DC88CAD03C0052499C1907B327FC63229EAB5B@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DC88CAD03C0052499C1907B327FC63229EAB5B@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jun 2013, J, KEERTHY wrote:

> Hello Grant/Lee Jones,
> 
> > -----Original Message-----
> > From: Lee Jones [mailto:lee.jones@linaro.org]
> > Sent: Thursday, June 06, 2013 12:36 PM
> > To: J, KEERTHY
> > Cc: linux-kernel@vger.kernel.org; grant.likely@secretlab.ca; linux-
> > doc@vger.kernel.org; devicetree-discuss@lists.ozlabs.org;
> > swarren@wwwdotorg.org; swarren@nvidia.com; rob.herring@calxeda.com;
> > rob@landley.net; sameo@linux.intel.com; wim@iguana.be;
> > lgirdwood@gmail.com; gg@slimlogic.co.uk; Kristo, Tero; Ian Lartey
> > Subject: Re: [PATCH v3] mfd: DT bindings for the palmas family MFD
> > 
> > On Thu, 06 Jun 2013, Lee Jones wrote:
> > 
> > > On Thu, 06 Jun 2013, J Keerthy wrote:
> > >
> > > > Add the various binding files for the palmas family of chips. There
> > > > is a top level MFD binding then a seperate binding for regulators
> > IP blocks on chips.
> > > >
> > > > Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> > > > Signed-off-by: J Keerthy <j-keerthy@ti.com>
> > > > Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> > > > Reviewed-by: Stephen Warren <swarren@nvidia.com>
> > > > ---
> > > >  Documentation/devicetree/bindings/mfd/palmas.txt   |   49
> > +++++++++++++
> > > >  .../devicetree/bindings/regulator/palmas-pmic.txt  |   72
> > ++++++++++++++++++++
> > > >  2 files changed, 121 insertions(+), 0 deletions(-)  create mode
> > > > 100644 Documentation/devicetree/bindings/mfd/palmas.txt
> > > >  create mode 100644
> > > > Documentation/devicetree/bindings/regulator/palmas-pmic.tx
> > >
> > > Applied, thanks.
> > 
> > Ah wait. It appears Grant wants to take this.
> > 
> > Unapplied, thanks. :)
> > 
> 
> Is it applied?

Not by me. I unapplied it when I saw that Grant took an earlier
revision.

I won't apply again unless Grant gives the nod. Failing that, I'm sure
he'll take it.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
