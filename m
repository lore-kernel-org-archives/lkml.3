Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaIYAKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 20:10:22 -0400
Received: from mail.kernel.org ([198.145.19.201]:45088 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751012AbaIYAKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 20:10:20 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Tim Bird <tim.bird@sonymobile.com>
Cc: Kumar Gala <galak@codeaurora.org>,
        "linux-arm-msm\@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Bjorn Andersson <Bjorn.Andersson@sonymobile.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd.bergmann\@linaro.org" <arnd.bergmann@linaro.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: dts: Add initial DTS file for Sony Xperia Z1
References: <5422DF46.90306@sonymobile.com>
Date: Wed, 24 Sep 2014 17:10:05 -0700
In-Reply-To: <5422DF46.90306@sonymobile.com> (Tim Bird's message of "Wed, 24
	Sep 2014 08:12:06 -0700")
Message-ID: <7h61gck1b6.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

Tim Bird <tim.bird@sonymobile.com> writes:

> This DTS has support for the Sony Xperia Z1 phone (codenamed Honami).
> This first version of the DTS supports just a serial console.
>
> changes from v1
>  - removed qcom,msm-id attribute
>  - removed mis-capitalized Qualcomm word
>  - changed dts file name
>  - added board-specific compatible-string
>
> Signed-off-by: Tim Bird <tim.bird@sonymobile.com>

[...]

> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index b8c5cd3..0c2702e 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -343,7 +343,8 @@ dtb-$(CONFIG_ARCH_QCOM) += \
>  	qcom-apq8074-dragonboard.dtb \
>  	qcom-apq8084-mtp.dtb \
>  	qcom-msm8660-surf.dtb \
> -	qcom-msm8960-cdp.dtb
> +	qcom-msm8960-cdp.dtb \
> +	qcom-msm8974-sony-honami-xperia.dtb

This doesn't compile becase the filename added is xperia-honami (not
honami-xperia)

After fixing that up, I was able to test it on my Z1 (Thanks Tim/Bjorn!)
but found I needed to add in the qcom,msm-id stuff first.  I guess that
will be remedied with the updated mkbootimg tool, correct?

Anyways, after fixing the filename, feel free to add:

Tested-by: Kevin Hilman <khilman@linaro.org>

Kevin
