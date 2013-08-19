Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab3HTAAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 20:00:06 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2435 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab3HTAAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 20:00:03 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <5212B17E.70602@broadcom.com>
Date: Mon, 19 Aug 2013 16:59:58 -0700
From: "Christian Daudt" <csd@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Christian Daudt" <csd@broadcom.com>
cc: "Lee Jones" <lee.jones@linaro.org>, "Alex Elder" <elder@linaro.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ian.campbell@citrix.com>,
        "Russell King" <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: add sdio blocks to bcm28155-ap board
References: <1375988874-11303-1-git-send-email-csd@broadcom.com>
 <1375988874-11303-2-git-send-email-csd@broadcom.com>
In-Reply-To: <1375988874-11303-2-git-send-email-csd@broadcom.com>
X-WSS-ID: 7E0C6F821R082180130-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-08-08 12:07 PM, Christian Daudt wrote:
> Enable sdio for bcm28155 AP board
>
> Reviewed-by: Alex Elder <elder@linaro.org>
> Signed-off-by: Christian Daudt <csd@broadcom.com>
>
> diff --git a/arch/arm/boot/dts/bcm28155-ap.dts b/arch/arm/boot/dts/bcm28155-ap.dts
> index 0d66db6..4b0a3ec 100644
> --- a/arch/arm/boot/dts/bcm28155-ap.dts
> +++ b/arch/arm/boot/dts/bcm28155-ap.dts
> @@ -26,4 +26,20 @@
>   	uart@3e000000 {
>   		status = "okay";
>   	};
> +
> +	sdio1: sdio@3f180000 {
> +		max-frequency = <48000000>;
> +		status = "okay";
> +	};
> +
> +	sdio2: sdio@3f190000 {
> +		non-removable;
> +		max-frequency = <48000000>;
> +		status = "okay";
> +	};
> +
> +	sdio4: sdio@3f1b0000 {
> +		max-frequency = <48000000>;
> +		status = "okay";
> +	};
>   };
applied to bcm/for-3.12/dt

  thanks,
     csd


