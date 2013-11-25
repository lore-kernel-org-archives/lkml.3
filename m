Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3KYLvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 06:51:17 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55835 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751128Ab3KYLvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 06:51:15 -0500
Date: Mon, 25 Nov 2013 11:50:52 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 1/2] dt-bindings: add hym8563 binding
Message-ID: <20131125115052.GC32081@e106331-lin.cambridge.arm.com>
References: <201311222254.07730.heiko@sntech.de>
 <201311222255.03642.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201311222255.03642.heiko@sntech.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 09:55:03PM +0000, Heiko Stübner wrote:
> Add binding documentation for the hym8563 rtc chip.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  .../devicetree/bindings/rtc/haoyu,hym8563.txt      |   29 ++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt
> 
> diff --git a/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt b/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt
> new file mode 100644
> index 0000000..2743416
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rtc/haoyu,hym8563.txt
> @@ -0,0 +1,29 @@
> +Haoyu Microelectronics HYM8563 Real Time Clock
> +
> +The HYM8563 provides basic rtc and alarm functionality
> +as well as a clock output of up to 32kHz.
> +
> +Required properties:
> +- compatible: should be: "haoyu,hym8563"

The "haoyu" vendor prefix will need to be documented (I couldn't spot it
in mainline's vendor-refixes.txt).

> +- reg: i2c address
> +- gpios: interrupt gpio

What's this used for exactly?

Thanks,
Mark.
