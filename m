Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3JAW7w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 18:59:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35594 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab3JAW7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 18:59:49 -0400
Date: Tue, 1 Oct 2013 17:58:48 -0500
From: Nishanth Menon <nm@ti.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>, <bcousson@baylibre.com>,
        <tony@atomide.com>, <linux-omap@vger.kernel.org>
CC: <swarren@wwwdotorg.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob.herring@calxeda.com>,
        <linux@roeck-us.net>, <rui.zhang@intel.com>, <grant.likely@linaro.org>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <lm-sensors@lm-sensors.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] DRA7: DT thermal support
Message-ID: <20131001225848.GA12365@kahuna>
References: <1380652344-18819-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1380652344-18819-1-git-send-email-eduardo.valentin@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:32-20131001, Eduardo Valentin wrote:
> Hello all,
> 
> This is a complementary patch series with themal DT support for DRA7.
> 
> Although this work depends on the thermal dt parser work [1], I decided
> to share it before hand. It also depends on DRA7 DT base port support,
> which I fetched from Rajendra's tree [2].
> 
> This patch series has been runtime tested on DRA7-evm.
> 
> All best,
> 
> [1] - https://lkml.org/lkml/2013/9/26/787
> [2] - git://github.com/rrnayak/linux.git out-of-tree/dra-integrated-v3
> 
> Eduardo Valentin (7):
>   arm: dts: add dra7 DSPEVE thermal data
>   arm: dts: add dra7 IVA thermal data
>   arm: dts: dra7: add bandgap entry
>   arm: dts: add cooling properties on dra7 cpu node
>   arm: dts: dra7: add thermal data
>   arm: dts: add tmp102 i2c sensor node on dra7-evm
>   arm: dts: add thermal zones info on tmp102 for DRA7-EVM
> 
>  arch/arm/boot/dts/dra7-dspeve-thermal.dtsi | 28 ++++++++++++++++++++++++++++
>  arch/arm/boot/dts/dra7-evm.dts             | 23 +++++++++++++++++++++++
>  arch/arm/boot/dts/dra7-iva-thermal.dtsi    | 28 ++++++++++++++++++++++++++++
>  arch/arm/boot/dts/dra7.dtsi                | 27 ++++++++++++++++++++++++++-
>  4 files changed, 105 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/boot/dts/dra7-dspeve-thermal.dtsi
>  create mode 100644 arch/arm/boot/dts/dra7-iva-thermal.dtsi

+Benoit, Tony, Linux-omap.
Ref: http://marc.info/?l=linux-pm&m=138065243027014&w=2

Tony, Benoit,
The following diff[1] is probably needed to ensure that right audience
is addressed.

Eduardo,
could you send an updated series with Tony,
Benoit and linux-omap in the loop?

[1]
diff --git a/MAINTAINERS b/MAINTAINERS
index 284969f..3442671 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5969,6 +5969,7 @@ M:	Tony Lindgren <tony@atomide.com>
 L:	linux-omap@vger.kernel.org
 L:	devicetree@vger.kernel.org
 S:	Maintained
+F:	arch/arm/boot/dts/*dra7*
 F:	arch/arm/boot/dts/*omap*
 F:	arch/arm/boot/dts/*am3*
 
-- 
Regards,
Nishanth Menon
