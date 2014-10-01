Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751376AbaJALV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 07:21:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60153 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbaJALV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 07:21:56 -0400
Date: Wed, 1 Oct 2014 12:21:50 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "artagnon@gmail.com" <artagnon@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chunyan.zhang" <chunyan.zhang@spreadtrum.com>
Subject: Re: [PATCH 1/6] Documentation: DT: Add bindings for Spreadtrum serial
Message-ID: <20141001112149.GA13759@leverpostej>
References: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com>
 <1411992293-7729-2-git-send-email-zhang.lyra@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411992293-7729-2-git-send-email-zhang.lyra@gmail.com>
Thread-Topic: [PATCH 1/6] Documentation: DT: Add bindings for Spreadtrum
 serial
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 01:04:48PM +0100, zhang.lyra@gmail.com wrote:
> From: "chunyan.zhang" <chunyan.zhang@spreadtrum.com>
> 
> Adds the device-tree documentation for Spreadtrum's serial.
> 
> Signed-off-by: chunyan.zhang <chunyan.zhang@spreadtrum.com>
> ---
>  .../devicetree/bindings/serial/of-serial.txt       |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt b/Documentation/devicetree/bindings/serial/of-serial.txt
> index 7705477..a0bb1d1 100644
> --- a/Documentation/devicetree/bindings/serial/of-serial.txt
> +++ b/Documentation/devicetree/bindings/serial/of-serial.txt
> @@ -14,6 +14,7 @@ Required properties:
>  	- "altr,16550-FIFO32"
>  	- "altr,16550-FIFO64"
>  	- "altr,16550-FIFO128"
> +	- "sprd,serial"

Is there not a more specific name? I'd imagine you might build a
different uart in future.

I didn't spot "sprd" in vendor-prefixes.txt in mainline. Is there a
patch adding that?

Mark.

>  	- "serial" if the port type is unknown.
>  - reg : offset and length of the register set for the device.
>  - interrupts : should contain uart interrupt.
> -- 
> 1.7.9.5
> 
> 
