Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbaHMOcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 10:32:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:41608 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbaHMOct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 10:32:49 -0400
Date: Wed, 13 Aug 2014 07:32:47 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/6] pinctrl: Add documentation for SPMI PMIC pinctrl
 driver bindings
Message-ID: <20140813143247.GE32301@codeaurora.org>
References: <1407771634-14946-1-git-send-email-iivanov@mm-sol.com>
 <1407771634-14946-4-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407771634-14946-4-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11, Ivan T. Ivanov wrote:
> diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,pmic-mpp.txt b/Documentation/devicetree/bindings/pinctrl/qcom,pmic-mpp.txt
> new file mode 100644
> index 0000000..0a64567
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/qcom,pmic-mpp.txt
> @@ -0,0 +1,179 @@
> +Qualcomm PMIC Multi-Purpose Pin (MPP) block
> +
> +This binding describes the MPP block(s) found in the 8xxx series of pmics from
> +Qualcomm.
> +
> +- compatible:
> +	Usage: required
> +	Value type: <string>
> +	Definition: must be one of:
> +		    "qcom,pm8841-mpp"
> +		    "qcom,pm8941-mpp"
> +		    "qcom,pma8084-mpp"
> +
> +- reg:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: Register base of the gpio block

MPP?

> +
> +- interrupts:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: Must contain an array of encoded interrupt specifiers for
> +		    each available gpio

MPP? Maybe gpio makes sense.

> +
> +- gpio-controller:
> +	Usage: required
> +	Value type: <none>
> +	Definition: Mark the device node as a GPIO controller
> +
> +- #gpio-cells:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: Must be 2;
> +		    the first cell will be used to define gpio number and the
> +		    second denotes the flags for this gpio
> +

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
