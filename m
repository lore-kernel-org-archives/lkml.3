Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab3JYDca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 23:32:30 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41440 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab3JYDc1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 23:32:27 -0400
Subject: Re: [PATCHv2] iio:light:tsl2563: Add DT support
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1382624835-10228-1-git-send-email-sre@debian.org>
Date: Thu, 24 Oct 2013 22:32:36 -0500
Cc: Sebastian Reichel <sre@ring0.de>, linux-iio@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Jonathan Cameron <jic23@cam.ac.uk>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <35B50A0C-D1F9-4D87-86DD-951BF71F2903@codeaurora.org>
References: <1382565063-17083-1-git-send-email-sre@debian.org> <1382624835-10228-1-git-send-email-sre@debian.org>
To: Sebastian Reichel <sre@debian.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 24, 2013, at 9:27 AM, Sebastian Reichel wrote:

> Add Device Tree support for the TSL2563 driver
> and document the binding.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
> .../devicetree/bindings/iio/light/tsl2563.txt         | 19 +++++++++++++++++++
> Documentation/devicetree/bindings/vendor-prefixes.txt |  1 +
> drivers/iio/light/tsl2563.c                           |  4 ++++
> 3 files changed, 24 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/iio/light/tsl2563.txt
> 
> diff --git a/Documentation/devicetree/bindings/iio/light/tsl2563.txt b/Documentation/devicetree/bindings/iio/light/tsl2563.txt
> new file mode 100644
> index 0000000..f91e809
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/light/tsl2563.txt
> @@ -0,0 +1,19 @@
> +* AMS TAOS TSL2563 ambient light sensor
> +
> +Required properties:
> +
> +  - compatible : should be "amstaos,tsl2563"
> +  - reg : the I2C address of the sensor
> +
> +Optional properties:
> +
> +  - amstaos,cover-comp-gain : integer used as multiplier for gain
> +                              compensation (default = 1)
> +
> +Example:
> +
> +tsl2563@29 {
> +	compatible = "amstaos,tsl2563";
> +	reg = <0x29>;
> +	amstaos,cover-comp-gain = <16>;
> +};

For the Binding, assuming another patch to add amstoas to the vendor list

Acked-by: Kumar Gala <galak@codeaurora.org>

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

