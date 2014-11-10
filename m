Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaKJTFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:05:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49298 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513AbaKJTFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:05:47 -0500
Message-ID: <54610C86.9090002@suse.de>
Date: Mon, 10 Nov 2014 20:05:42 +0100
From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Liviu Dudau <Liviu.Dudau@arm.com>, arm@kernel.org,
        Olof Johansson <olof@lixom.net>
CC: Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        device tree <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/2] arm64: Add Juno SoC device tree.
References: <1415618875-8469-1-git-send-email-Liviu.Dudau@arm.com> <1415618875-8469-3-git-send-email-Liviu.Dudau@arm.com>
In-Reply-To: <1415618875-8469-3-git-send-email-Liviu.Dudau@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 10.11.2014 um 12:27 schrieb Liviu Dudau:
> diff --git a/arch/arm64/boot/dts/juno.dts b/arch/arm64/boot/dts/juno.dts
> new file mode 100644
> index 0000000..7f998de
> --- /dev/null
> +++ b/arch/arm64/boot/dts/juno.dts
> @@ -0,0 +1,374 @@
> +/*
> + * ARM Ltd. Juno Plaform

"Platform"

> + *

Shouldn't this mention a license, ideally dual-licensed?

> + */
> +
> +/dts-v1/;
> +
> +#include <dt-bindings/interrupt-controller/arm-gic.h>
> +
> +/ {
> +	model = "Juno";
> +	compatible = "arm,juno", "arm,vexpress";
> +	interrupt-parent = <&gic>;
> +	#address-cells = <2>;
> +	#size-cells = <2>;
> +
> +	aliases {
> +		serial0 = &soc_uart0;
> +	};
> +
> +	cpus {
> +		#address-cells = <2>;
> +		#size-cells = <0>;
> +
> +		A53_0:cpu@100 {
[snip]

Can you please add a space after colon, like you did for non-CPU nodes?

Regards,
Andreas

-- 
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 21284 AG Nürnberg
