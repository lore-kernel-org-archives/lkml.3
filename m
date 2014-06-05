Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaFEWNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 18:13:07 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:16844 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbaFEWNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 18:13:06 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 05 Jun 2014 15:05:01 -0700
Date: Fri, 6 Jun 2014 01:13:01 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Linus Walleij" <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 4/5] ARM: tegra: Add efuse and apbmisc bindings
Message-ID: <20140605221301.GQ5961@tbergstrom-lnx.Nvidia.com>
References: <1401973754-19701-1-git-send-email-pdeschrijver@nvidia.com>
 <1401973754-19701-5-git-send-email-pdeschrijver@nvidia.com>
 <5390B9F3.8030108@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5390B9F3.8030108@wwwdotorg.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 08:41:55PM +0200, Stephen Warren wrote:
> On 06/05/2014 07:09 AM, Peter De Schrijver wrote:
> > Add efuse and apbmisc bindings for Tegra20, Tegra30, Tegra114 and Tegra124.
> 
> > diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
> 
> > +	apbmisc@70000800 {
> > +		compatible = "nvidia,tegra114-apbmisc", "nvidia,tegra20-apbmisc";
> 
> Is the Tegra114 APBMISC register layout 100% a backwards-compatible
> superset of that in Tegra20? For both registers the code currently uses
> *and* all possible registers the code could ever use? Since the APB MISC
> is a bit of a dumping ground for random registers, that feels unlikely,
> but perhaps it's possible.

For all I can see it is. At least for the registers the kernel is likely to
use.

Cheers,

Peter.
