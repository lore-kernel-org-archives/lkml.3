Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760046Ab3HNQGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:06:37 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46767 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765Ab3HNQGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:06:33 -0400
Message-ID: <520BAB07.8050203@codeaurora.org>
Date: Wed, 14 Aug 2013 09:06:31 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: balbi@ti.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob@landley.net, gregkh@linuxfoundation.org, grant.likely@linaro.org,
        idos@codeaurora.org, mgautam@codeaurora.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v3 3/3] usb: dwc3: Add Qualcomm DWC3 glue layer driver
References: <1376485183-2664-1-git-send-email-iivanov@mm-sol.com> <1376485183-2664-4-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1376485183-2664-4-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/13 05:59, Ivan T. Ivanov wrote:
> +}
> +
> +static const struct of_device_id of_dwc3_matach[] = {

match? Maybe you can make it all one line too { .compatible = "qcom,dwc3" }

> +	{
> +		.compatible = "qcom,dwc3",
> +	},
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, of_dwc3_matach);
> +
>
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

