Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaETPlw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 11:41:52 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13653 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbaETPlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 11:41:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 20 May 2014 08:36:55 -0700
Date: Tue, 20 May 2014 18:41:45 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Andrew Bresticker <abrestic@chromium.org>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "Prashant Gaikwad" <pgaikwad@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Mathias Nyman" <mathias.nyman@intel.com>,
        Pawel Moll <pawel.moll@arm.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Jim Lin <jilin@nvidia.com>, "Kishon Vijay Abraham I" <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC PATCH 04/10] clk: tegra: Initialize xusb clocks
Message-ID: <20140520154145.GY15168@tbergstrom-lnx.Nvidia.com>
References: <1400113986-339-1-git-send-email-abrestic@chromium.org>
 <1400113986-339-5-git-send-email-abrestic@chromium.org>
 <537513D8.7060203@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <537513D8.7060203@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 09:22:00PM +0200, Stephen Warren wrote:
> On 05/14/2014 06:33 PM, Andrew Bresticker wrote:
> > Initialize the XUSB-related clocks with appropriate parents and rates
> > for both Tegra114 and Tegra124.
> 
> These first 4 clock driver patches look plausible to me, although I
> didn't look that hard!
> 
> Peter or Mike, if they look OK to you, can you please pick them up for
> 3.16 so that by the time we apply the rest of the patches in this series
> for 3.17, the clock dependencies are already there? Thanks.

Looks fine to me. Applied for 3.16, hopefully it will still make it.

Cheers,

Peter.
