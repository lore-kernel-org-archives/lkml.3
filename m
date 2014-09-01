Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaIACq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 22:46:57 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:58539 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaIACqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 22:46:55 -0400
Date: Mon, 1 Sep 2014 11:46:48 +0900
From: Gyungoh Yoo <gyungoh@gmail.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: jack.yoo@skyworksinc.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/7] Adding SKY81452 regulator device tree bindings
 document
Message-ID: <20140901024648.GA5615@jack-ThinkPad-T520>
References: <1409222307-23225-1-git-send-email-jack.yoo@skyworksinc.com>
 <1409223518-23566-1-git-send-email-jack.yoo@skyworksinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1409223518-23566-1-git-send-email-jack.yoo@skyworksinc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ingnore 'only' this patch.

When sky81452-regulator driver was applied before,
The previous version of this document 'sky81452-regulator.txt' was applied.
I will resubmit the changes as incremental patches against current code of sky81452-regulator.txt.

I am sorry for confusiong.
Thank you.

On Thu, Aug 28, 2014 at 07:58:38PM +0900, Gyungoh Yoo wrote:
> v2:
> Added 'compatible' attribute in child drivers
> 
> ---
>  .../bindings/regulator/sky81452-regulator.txt          | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/regulator/sky81452-regulator.txt
> 
> diff --git a/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt b/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt
> new file mode 100644
> index 0000000..7b9ff18
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/sky81452-regulator.txt
> @@ -0,0 +1,18 @@
> +SKY81452 voltage regulator
> +
> +Required properties:
> +- compatible	: Must be "skyworks,sky81452-regulator"
> +- any required generic properties defined in regulator.txt
> +
> +Optional properties:
> +- any available generic properties defined in regulator.txt
> +
> +Example:
> +
> +	regulator {
> +		compatible = "skyworks,sky81452-regulator";
> +		/* generic regulator properties */
> +		regulator-name = "touch_en";
> +		regulator-min-microvolt = <4500000>;
> +		regulator-max-microvolt = <8000000>;
> +	};
> -- 
> 1.9.1
> 
