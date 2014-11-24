Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaKXKdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:33:45 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:44694 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaKXKdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:33:42 -0500
Date: Mon, 24 Nov 2014 10:33:34 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Josh Cartwright <joshc@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: devicetree: qcom_rpm: document IPQ8064 resources
Message-ID: <20141124103334.GF4241@x1>
References: <1416512485-7292-1-git-send-email-joshc@codeaurora.org>
 <1416512485-7292-2-git-send-email-joshc@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1416512485-7292-2-git-send-email-joshc@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014, Josh Cartwright wrote:

> The IPQ8064 SoC has several RPM-controlled resources, an NSS fabrick
> clock and four regulator resources.  Provide definitions for them.
> 
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
> ---
>  Documentation/devicetree/bindings/mfd/qcom-rpm.txt | 6 +++++-
>  include/dt-bindings/mfd/qcom-rpm.h                 | 6 ++++++
>  2 files changed, 11 insertions(+), 1 deletion(-)

What do you want me to do with this patch?  I'm guessing the other
patches in the set depend on these new defines?  I can't even check
because you've only send me 2 of the 3 patches in the set.

> diff --git a/Documentation/devicetree/bindings/mfd/qcom-rpm.txt b/Documentation/devicetree/bindings/mfd/qcom-rpm.txt
> index 4264021..6d4e3ec 100644
> --- a/Documentation/devicetree/bindings/mfd/qcom-rpm.txt
> +++ b/Documentation/devicetree/bindings/mfd/qcom-rpm.txt
> @@ -12,6 +12,7 @@ frequencies.
>  		    "qcom,rpm-apq8064"
>  		    "qcom,rpm-msm8660"
>  		    "qcom,rpm-msm8960"
> +		    "qcom,rpm-ipq8064"
>  
>  - reg:
>  	Usage: required
> @@ -67,6 +68,7 @@ of valid subnodes that can operate on these resources.
>  		    "qcom,rpm-pm8901-ftsmps"
>  		    "qcom,rpm-pm8921-smps"
>  		    "qcom,rpm-pm8921-ftsmps"
> +		    "qcom,rpm-smb208"
>  
>  - reg:
>  	Usage: required
> @@ -76,7 +78,9 @@ of valid subnodes that can operate on these resources.
>  		    QCOM_RPM_PM8058_SMPS0 - QCOM_RPM_PM8058_SMPS4,
>  		    QCOM_RPM_PM8821_SMPS1 - QCOM_RPM_PM8821_SMPS2,
>  		    QCOM_RPM_PM8901_SMPS0 - QCOM_RPM_PM8901_SMPS4,
> -		    QCOM_RPM_PM8921_SMPS1 - QCOM_RPM_PM8921_SMPS8
> +		    QCOM_RPM_PM8921_SMPS1 - QCOM_RPM_PM8921_SMPS8,
> +		    QCOM_RPM_SMB208_S1a, QCOM_RPM_SMB208_S1b,
> +		    QCOM_RPM_SMB208_S2a, QCOM_RPM_SMB208_S2b
>  
>  - bias-pull-down:
>  	Usage: optional
> diff --git a/include/dt-bindings/mfd/qcom-rpm.h b/include/dt-bindings/mfd/qcom-rpm.h
> index 388a6f3..13a9d4b 100644
> --- a/include/dt-bindings/mfd/qcom-rpm.h
> +++ b/include/dt-bindings/mfd/qcom-rpm.h
> @@ -141,6 +141,12 @@
>  #define QCOM_RPM_SYS_FABRIC_MODE		131
>  #define QCOM_RPM_USB_OTG_SWITCH			132
>  #define QCOM_RPM_VDDMIN_GPIO			133
> +#define QCOM_RPM_NSS_FABRIC_0_CLK		134
> +#define QCOM_RPM_NSS_FABRIC_1_CLK		135
> +#define QCOM_RPM_SMB208_S1a			136
> +#define QCOM_RPM_SMB208_S1b			137
> +#define QCOM_RPM_SMB208_S2a			138
> +#define QCOM_RPM_SMB208_S2b			139
>  
>  /*
>   * Constants used to select force mode for regulators.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
