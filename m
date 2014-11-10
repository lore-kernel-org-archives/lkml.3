Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaKJUAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:00:14 -0500
Received: from service87.mimecast.com ([91.220.42.44]:33399 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbaKJUAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:00:11 -0500
Date: Mon, 10 Nov 2014 20:00:05 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
Cc: "arm@kernel.org" <arm@kernel.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        device tree <devicetree@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/2] arm64: Add Juno SoC device tree.
Message-ID: <20141110200005.GA10247@e106497-lin.cambridge.arm.com>
References: <1415618875-8469-1-git-send-email-Liviu.Dudau@arm.com>
 <1415618875-8469-3-git-send-email-Liviu.Dudau@arm.com>
 <54610C86.9090002@suse.de>
MIME-Version: 1.0
In-Reply-To: <54610C86.9090002@suse.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 10 Nov 2014 20:00:06.0665 (UTC) FILETIME=[EC8F9F90:01CFFD20]
X-MC-Unique: 114111020000702801
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 07:05:42PM +0000, Andreas Färber wrote:
> Hi,
> 
> Am 10.11.2014 um 12:27 schrieb Liviu Dudau:
> > diff --git a/arch/arm64/boot/dts/juno.dts b/arch/arm64/boot/dts/juno.dts
> > new file mode 100644
> > index 0000000..7f998de
> > --- /dev/null
> > +++ b/arch/arm64/boot/dts/juno.dts
> > @@ -0,0 +1,374 @@
> > +/*
> > + * ARM Ltd. Juno Plaform
> 
> "Platform"
> 
> > + *
> 
> Shouldn't this mention a license, ideally dual-licensed?

Hi Andreas,

TBH I wasn't sure a license was needed. Most (all?) of ARM's DT
files don't seem to carry a license, but I will add the appropriate
license. And yes, it is dual-licensed (GPLv2 or BSD)

> 
> > + */
> > +
> > +/dts-v1/;
> > +
> > +#include <dt-bindings/interrupt-controller/arm-gic.h>
> > +
> > +/ {
> > +	model = "Juno";
> > +	compatible = "arm,juno", "arm,vexpress";
> > +	interrupt-parent = <&gic>;
> > +	#address-cells = <2>;
> > +	#size-cells = <2>;
> > +
> > +	aliases {
> > +		serial0 = &soc_uart0;
> > +	};
> > +
> > +	cpus {
> > +		#address-cells = <2>;
> > +		#size-cells = <0>;
> > +
> > +		A53_0:cpu@100 {
> [snip]
> 
> Can you please add a space after colon, like you did for non-CPU nodes?

Sure, will do.

Best regards,
Liviu

> 
> Regards,
> Andreas
> 
> -- 
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
> GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 21284 AG Nürnberg
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

