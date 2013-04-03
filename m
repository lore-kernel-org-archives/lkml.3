Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550Ab3DCOTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:19:51 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15846 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759285Ab3DCOTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:19:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 03 Apr 2013 07:19:19 -0700
Date: Wed, 3 Apr 2013 17:19:16 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, "Rob Landley" <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        Simon Glass <sjg@chromium.org>, Rhyland Klein <rklein@nvidia.com>,
        Pritesh Raithatha <praithatha@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, Andrew Chew <AChew@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 10/14] ARM: tegra: Define Tegra114 CAR binding
Message-ID: <20130403141916.GS18519@tbergstrom-lnx.Nvidia.com>
References: <1363956029-31873-1-git-send-email-pdeschrijver@nvidia.com>
 <1363956029-31873-11-git-send-email-pdeschrijver@nvidia.com>
 <515031E3.40007@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <515031E3.40007@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 12:15:47PM +0100, Prashant Gaikwad wrote:
> On Friday 22 March 2013 06:09 PM, Peter De Schrijver wrote:
> > The device tree binding models Tegra114 CAR (Clock And Reset) as a single
> > monolithic clock provider.
> >
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > ---
> 
> <snip>
> 
> > +  263	cclk_lp
> > +  264	dfll_ref
> > +  265	dfll_soc
> > +
> 
> Peter,
> 
> Please remove following clock IDs from binding.
> 
> > +Mux clocks
> > +

...
> > +  306	clk_out_1_mux

Is at least used by the init list. So we can't remove that?

Cheers,

Peter.
