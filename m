Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191AbaKTUPE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 15:15:04 -0500
Received: from mout.web.de ([212.227.17.11]:54401 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757925AbaKTUPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 15:15:01 -0500
Message-ID: <546E4BA6.5020606@web.de>
Date: Thu, 20 Nov 2014 21:14:30 +0100
From: Soeren Moch <smoch@web.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org, Soeren Moch <smoch@web.de>
Subject: Re: [PATCH] ARM: dts: imx6q-tbs2910: Enable snvs-poweroff
References: <1416380089-6317-1-git-send-email-smoch@web.de>
In-Reply-To: <1416380089-6317-1-git-send-email-smoch@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:nxZgDjyk30y1aG52TQZOnd398W29e1lQEm5ID+VlNTaLi2gbSZr
 wG7WswBp0D2ziENhHivOh75cdy36rgzXKtxlgL4U1ybnF9rae6lGWDkvrS/Nd7H/fO2WKdN
 p3i+E/SopyANwqzN5jlH8NWUOGRdQtqEvUGUiziJm5Vhrr7eQNPU3dE2gp1kzCB3wYqVAFp
 7phkLflDPAFXQNlXHhykg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/14 07:54, Soeren Moch wrote:
> This patch enables snvs-poweroff for TBS2910 boards.
>
> Signed-off-by: Soeren Moch <smoch@web.de>
> --
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Sascha Hauer <kernel@pengutronix.de>
> Cc: linux-kernel@vger.kernel.org
> ---
>   arch/arm/boot/dts/imx6q-tbs2910.dts | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/arch/arm/boot/dts/imx6q-tbs2910.dts b/arch/arm/boot/dts/imx6q-tbs2910.dts
> index d2a5743..7e7496c 100644
> --- a/arch/arm/boot/dts/imx6q-tbs2910.dts
> +++ b/arch/arm/boot/dts/imx6q-tbs2910.dts
> @@ -208,6 +208,10 @@
>   	status = "okay";
>   };
>   
> +&snvs_poweroff {
> +	status = "okay";
> +};
> +
>   &spdif {
>   	pinctrl-names = "default";
>   	pinctrl-0 = <&pinctrl_spdif>;
Shawn,

since snvs_poweroffis applied now, can you take this patch for 3.19?

Thanks,
Soeren

