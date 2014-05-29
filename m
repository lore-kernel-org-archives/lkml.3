Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934119AbaE2Qyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:54:47 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:48392 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867AbaE2Qyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:54:44 -0400
Date: Thu, 29 May 2014 17:54:37 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: devicetree: bindings: Add Qualcomm RPM DT
 binding
Message-ID: <20140529165437.GM1954@lee--X1>
References: <1401211721-19712-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1401211721-19712-2-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401211721-19712-2-git-send-email-bjorn.andersson@sonymobile.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add binding for the Qualcomm Resource Power Manager (RPM) found in 8660, 8960
> and 8064 based devices. The binding currently describes the rpm itself and the
> regulator subnodes.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
>  Documentation/devicetree/bindings/mfd/qcom,rpm.txt | 284 +++++++++++++++++++++
>  include/dt-bindings/mfd/qcom_rpm.h                 | 142 +++++++++++
>  2 files changed, 426 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mfd/qcom,rpm.txt
>  create mode 100644 include/dt-bindings/mfd/qcom_rpm.h

[...]

> diff --git a/include/dt-bindings/mfd/qcom_rpm.h b/include/dt-bindings/mfd/qcom_rpm.h
> new file mode 100644
> index 0000000..277e789
> --- /dev/null
> +++ b/include/dt-bindings/mfd/qcom_rpm.h
> @@ -0,0 +1,142 @@
> +/*
> + * This header provides constants for the Qualcomm RPM bindings.
> + */

Proper header please.

> +#ifndef _DT_BINDINGS_MFD_QCOM_RPM_H
> +#define _DT_BINDINGS_MFD_QCOM_RPM_H
> +
> +#define QCOM_RPM_APPS_FABRIC_ARB		1
> +#define QCOM_RPM_APPS_FABRIC_CLK		2
> +#define QCOM_RPM_APPS_FABRIC_HALT		3

[...]

> +#define QCOM_RPM_SYS_FABRIC_MODE		131
> +#define QCOM_RPM_USB_OTG_SWITCH		132
> +#define QCOM_RPM_VDDMIN_GPIO			133

Are you sure you don't want these in 0xXY format?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
