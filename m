Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab3BKKD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 05:03:28 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11372 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab3BKKD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 05:03:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 11 Feb 2013 02:00:42 -0800
Date: Mon, 11 Feb 2013 12:03:10 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Felipe Balbi <balbi@ti.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 08/10] ARM: dt: Add references to tegra_car clocks
Message-ID: <20130211100310.GZ3073@tbergstrom-lnx.Nvidia.com>
References: <1360330602-30472-1-git-send-email-pdeschrijver@nvidia.com>
 <1360330602-30472-9-git-send-email-pdeschrijver@nvidia.com>
 <20130208140301.GA23979@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130208140301.GA23979@arwen.pp.htv.fi>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 03:03:02PM +0100, Felipe Balbi wrote:
> * PGP Signed by an unknown key
> 
> Hi,
> 
> On Fri, Feb 08, 2013 at 03:36:40PM +0200, Peter De Schrijver wrote:
> >  	tegra_car: clock {
> > -		compatible = "nvidia,tegra114-car, nvidia,tegra30-car";
> > +		compatible = "nvidia,tegra114-car";
> 
> trailing change or intentional ?

No, the Tegra30 car driver shouldn't be used for Tegra114.

Cheers,

Peter.
