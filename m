Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324Ab3CUOIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:08:15 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:47859 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755565Ab3CUOIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:08:13 -0400
Message-ID: <514B1412.9060707@cogentembedded.com>
Date: Thu, 21 Mar 2013 18:07:14 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: swarren@nvidia.com, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 1/4] ARM: tegra: dalmore: add cpu regulator node
References: <1363873663-19272-1-git-send-email-ldewangan@nvidia.com> <1363873663-19272-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1363873663-19272-2-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 21-03-2013 17:47, Laxman Dewangan wrote:

> Dalmore uses the TPS51632 as CPU regulator. The device is connected
> on I2C5.

> Add DT node for TPS51632.

> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>   arch/arm/boot/dts/tegra114-dalmore.dts |   15 +++++++++++++++
>   1 files changed, 15 insertions(+), 0 deletions(-)

> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
> index a61974e..6be9434 100644
> --- a/arch/arm/boot/dts/tegra114-dalmore.dts
> +++ b/arch/arm/boot/dts/tegra114-dalmore.dts
> @@ -718,6 +718,21 @@
>   		clock-frequency = <408000000>;
>   	};
>
> +	i2c@7000d000 {
> +		status = "okay";
> +		clock-frequency = <400000>;
> +
> +		tps51632 {

    Should be named "tps51632@43" I think.

> +			compatible = "ti,tps51632";
> +			reg = <0x43>;

WBR, Sergei


