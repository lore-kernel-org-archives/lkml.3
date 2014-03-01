Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaCALth (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 06:49:37 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:52465 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaCALtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 06:49:35 -0500
Message-ID: <5311C97E.5070307@kernel.org>
Date: Sat, 01 Mar 2014 11:50:22 +0000
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
Subject: Re: [RFCv4 6/7] Documentation: DT: Document twl4030-madc binding
References: <1393374270-20079-1-git-send-email-sre@debian.org> <1393444990-28140-1-git-send-email-sre@debian.org> <1393444990-28140-7-git-send-email-sre@debian.org>
In-Reply-To: <1393444990-28140-7-git-send-email-sre@debian.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/02/14 20:03, Sebastian Reichel wrote:
> Add devicetree binding documentation for twl4030-madc
> analog digital converter.
>
> Signed-off-by: Sebastian Reichel <sre@debian.org>
Looks fine to me, but as ever needs a device tree maintainer ack or
3 weeks and someone else to take a view on it.

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

