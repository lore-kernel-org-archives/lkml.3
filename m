Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbaLONGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 08:06:52 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60056 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750711AbaLONGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 08:06:50 -0500
Date: Mon, 15 Dec 2014 13:02:48 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Nikolaus Schulz <nikolaus.schulz@avionic-design.de>
Cc: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alban Bedel <alban.bedel@avionic-design.de>
Subject: Re: [PATCH v3 1/2] iio: document ti-dac8554 devicetree bindings
Message-ID: <20141215130248.GA8264@leverpostej>
References: <1418643605-15554-1-git-send-email-nikolaus.schulz@avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418643605-15554-1-git-send-email-nikolaus.schulz@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 11:39:56AM +0000, Nikolaus Schulz wrote:
> Signed-off-by: Nikolaus Schulz <nikolaus.schulz@avionic-design.de>
> ---
>  .../devicetree/bindings/iio/dac/ti-dac8554.txt     | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/dac/ti-dac8554.txt
> 
> diff --git a/Documentation/devicetree/bindings/iio/dac/ti-dac8554.txt b/Documentation/devicetree/bindings/iio/dac/ti-dac8554.txt
> new file mode 100644
> index 0000000..32e96859
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/dac/ti-dac8554.txt
> @@ -0,0 +1,22 @@
> +TI DAC8554 Digital to Analog Converter
> +
> +This driver supports the SPI bus.

The binding need not refer to the driver, this sentence can go. It might
be worth adding "(SPI)" to the first line.

> +
> +Required properties:
> +	- compatible: must be "ti,dac8554"
> +	- vref-supply: the vref power supply
> +	- ti,address: the additional 2-bit chip address
> +
> +For required properties on SPI, please consult
> +Documentation/devicetree/bindings/spi/spi-bus.txt
> +
> +Example:
> +
> +	dac8554@0 {
> +		compatible = "ti,dac8554";
> +		reg = <0>;
> +		spi-max-frequency = <50000000>;
> +
> +		vref-supply = <&vdd_vref>;
> +		ti,address = <0>;

What's this property used for?

> +	};

Otherwise this looks sane to me.

Mark.
