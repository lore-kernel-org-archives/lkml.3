Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab3CPCCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 22:02:32 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19965 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755339Ab3CPCCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 22:02:31 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 15 Mar 2013 18:55:32 -0700
Message-ID: <1363399371.2879.10.camel@bilhuang-vm1>
Subject: Re: [PATCH 1/1] mfd: palmas: Add power off control
From: Bill Huang <bilhuang@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Stephen Warren <swarren@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "Laxman Dewangan" <ldewangan@nvidia.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 15 Mar 2013 19:02:51 -0700
In-Reply-To: <514358BC.4030600@wwwdotorg.org>
References: <1363258680-12600-1-git-send-email-bilhuang@nvidia.com>
	 <5142AF55.80708@nvidia.com> <1363326713.3311.50.camel@bilhuang-vm1>
	 <514358BC.4030600@wwwdotorg.org>
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-03-16 at 01:22 +0800, Stephen Warren wrote:
> On 03/14/2013 11:51 PM, Bill Huang wrote:
> > On Fri, 2013-03-15 at 13:19 +0800, Stephen Warren wrote:
> >> On 03/14/2013 04:58 AM, Bill Huang wrote:
> >>> Hook up "pm_power_off" to palmas power off routine if there is DT
> >>> property "ti,system-power-controller" defined, so platform which is
> >>> powered by this regulator can be powered off properly.
> >>
> >>> diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
> >>
> >>> +	pdata->pm_off = of_property_read_bool(node,
> >>> +			"ti,system-power-controller");
> >>
> >> You would need to add that property to the DT binding documentation for
> >> this device.
> >
> > Does it work that some time later Laxmain helps to add it when he
> > submits his pmic bindings for Palmas?
> 
> I'll note that Ian Lartey and Graeme Gregory actually seem to be the
> people defining the PMIC bindings for Palmas. See:
> 
> http://comments.gmane.org/gmane.linux.documentation/9948
> 
> Or is Laxman planning to send some updates to that?
> 
> But irrespective of that no, I don't think that influences this at all;
> if you introduce driver support for new DT content, then either that DT
> content should already be documented in the binding, or this patch
> should add it to the documentation.

Thanks, here I just need to add a property into the DT bindings but
currently there is no any Palmas binding document exist so that means I
have to hold off the patch.


