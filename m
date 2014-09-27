Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbaI0Kwf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 06:52:35 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:36285 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbaI0Kwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 06:52:33 -0400
Message-ID: <542696EE.5000706@kernel.org>
Date: Sat, 27 Sep 2014 11:52:30 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-iio@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, linux-api@vger.kernel.org
CC: linux-kernel@vger.kernel.org, support.opensource@diasemi.com
Subject: Re: [PATCH 4/8] iio: da9150: Add DT binding documentation for GPADC
References: <cover.1411396718.git.Adam.Thomson.Opensource@diasemi.com> <6697dbc9711c9c3551aede1b5e4f986caa0d1a44.1411396719.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <6697dbc9711c9c3551aede1b5e4f986caa0d1a44.1411396719.git.Adam.Thomson.Opensource@diasemi.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/09/14 11:53, Adam Thomson wrote:
> Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>
> ---
>  .../devicetree/bindings/iio/adc/da9150-gpadc.txt         | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/adc/da9150-gpadc.txt
> 
> diff --git a/Documentation/devicetree/bindings/iio/adc/da9150-gpadc.txt b/Documentation/devicetree/bindings/iio/adc/da9150-gpadc.txt
> new file mode 100644
> index 0000000..c07228d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/adc/da9150-gpadc.txt
> @@ -0,0 +1,16 @@
> +Dialog Semiconductor DA9150 IIO GPADC bindings
> +
> +Required properties:
> +- compatible: "dlg,da9150-gpadc" for DA9150 IIO GPADC
> +- #io-channel-cells: Should be set to <1>
> +  (See Documentation/devicetree/bindings/iio/iio-bindings.txt for further info)
> +
> +For further information on GPADC channels, see device datasheet.
> +
> +
> +Example:
> +
> +	gpadc: da9150-gpadc {
> +		compatible = "dlg,da9150-gpadc";
> +		#io-channel-cells = <1>;
> +	};
> --
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
