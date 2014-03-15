Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbaCOP0b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 11:26:31 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60300 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbaCOP02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 11:26:28 -0400
Message-ID: <5324715F.4030106@kernel.org>
Date: Sat, 15 Mar 2014 15:27:27 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Marek Belisko <marek@goldelico.com>
CC: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org
Subject: Re: [PATCHv2 6/9] Documentation: DT: Document twl4030-madc binding
References: <1393702365-26429-1-git-send-email-sre@debian.org> <1393970751-18157-1-git-send-email-sre@debian.org> <1393970751-18157-7-git-send-email-sre@debian.org>
In-Reply-To: <1393970751-18157-7-git-send-email-sre@debian.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/14 22:05, Sebastian Reichel wrote:
> Add devicetree binding documentation for twl4030-madc
> analog digital converter.
>
> Signed-off-by: Sebastian Reichel <sre@debian.org>
I'm happy with this, but it needs the usual sign off form a device tree
maintainer or 3 weeks to pass since it was posted.
Acked-by: Jonathan Cameron <jic23@kernel.org>
> ---
>   .../devicetree/bindings/iio/adc/twl4030-madc.txt   | 24 ++++++++++++++++++++++
>   1 file changed, 24 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt
>
> diff --git a/Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt b/Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt
> new file mode 100644
> index 0000000..6bdd214
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/adc/twl4030-madc.txt
> @@ -0,0 +1,24 @@
> +* TWL4030 Monitoring Analog to Digital Converter (MADC)
> +
> +The MADC subsystem in the TWL4030 consists of a 10-bit ADC
> +combined with a 16-input analog multiplexer.
> +
> +Required properties:
> +  - compatible: Should contain "ti,twl4030-madc".
> +  - interrupts: IRQ line for the MADC submodule.
> +  - #io-channel-cells: Should be set to <1>.
> +
> +Optional properties:
> +  - ti,system-uses-second-madc-irq: boolean, set if the second madc irq register
> +				    should be used, which is intended to be used
> +				    by Co-Processors (e.g. a modem).
> +
> +Example:
> +
> +&twl {
> +	madc {
> +		compatible = "ti,twl4030-madc";
> +		interrupts = <3>;
> +		#io-channel-cells = <1>;
> +	};
> +};
>

