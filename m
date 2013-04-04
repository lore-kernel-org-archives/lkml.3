Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764191Ab3DDRwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:52:40 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18958 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764163Ab3DDRwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:52:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 04 Apr 2013 10:52:09 -0700
Date: Thu, 4 Apr 2013 20:52:06 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Mike Turquette <mturquette@linaro.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, Simon Glass <sjg@chromium.org>,
        Joseph Lo <josephl@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 00/12] Tegra114 clockframework
Message-ID: <20130404175206.GD18519@tbergstrom-lnx.Nvidia.com>
References: <1360931849-7090-1-git-send-email-pdeschrijver@nvidia.com>
 <5123C6E7.9070407@wwwdotorg.org>
 <20130219185034.27993.86892@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130219185034.27993.86892@quantum>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

> Quoting Stephen Warren (2013-02-19 10:39:35)
> > On 02/15/2013 05:36 AM, Peter De Schrijver wrote:
> > > This is the seventh version of the Tegra114 clockframework. It is based on the
> > > for-next branch of
> > > git://git.kernel.org/pub/scm/linux/kernel/git/swarren/linux-tegra.git and
> > > http://www.spinics.net/lists/arm-kernel/msg220452.html.
> > 
> > Mike,
> > 
> > I think it'd be prudent to take this series through the Tegra tree again
> > for 3.10; patch 11 needs to go in as part of the series due to internal
> > dependencies, and I'm slightly worried that other Tegra DT changes might
> > conflict with that patch (if only for context). Taking this series (and
> > any other Tegra clk driver changes for 3.10) through the Tegra tree
> > could resolve that easily. Do you have a problem with that?
> > 
> 
> I was thinking the same thing.  I'll make time to review these now that
> 3.8 is out.
> 

I posted v9 of this yesterday (http://www.spinics.net/lists/linux-tegra/msg10891.html)
and posted a small binding doc update today 
'[PATCH v9b 10/14] ARM: tegra: Define Tegra114 CAR binding'. Can you ack these so
Stephen can take them in the Tegra tree?

Thanks!

Peter.
