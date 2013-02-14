Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760563Ab3BNO6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 09:58:20 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5209 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339Ab3BNO6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 09:58:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 14 Feb 2013 06:58:05 -0800
Date: Thu, 14 Feb 2013 16:58:02 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Hiroshi Doyu <hdoyu@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] ARM: dt: add header to define tegra20 clocks
Message-ID: <20130214145802.GK3073@tbergstrom-lnx.Nvidia.com>
References: <1360791198-29462-1-git-send-email-swarren@wwwdotorg.org>
 <1360823899-17846-1-git-send-email-hdoyu@nvidia.com>
 <20130214101220.GI3073@tbergstrom-lnx.Nvidia.com>
 <20130214.154250.475978229890081002.hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130214.154250.475978229890081002.hdoyu@nvidia.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There could be the same kind of requirement from others that both
> "dtsip" and "C-source" want to share the same header file. If we
> consider that DT is the exact H/W description, C-source should be able
> to include a DT header file.
> 
> For example, a C-header file for "enum tegra{20,30}_clk" should be
> generated from "arch/arm/boot/dts/tegra{20,30}-car.h" at runtime, or
> alternatively just "drivers/clk/tegra/clk-tegra{20,30}.c" can include
> "arch/arm/boot/dts/tegra{20,30}-car.h"? The latter may be easier.

Including arch/arm/boot/dts/tegra{20,30}-car.h seems to make much more sense
to me than generating a enum based on #defines... :)

Cheers,

Peter.
