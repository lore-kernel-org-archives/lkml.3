Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab3GHPvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 11:51:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44027 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3GHPvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 11:51:11 -0400
Message-ID: <51DADFEC.1050901@wwwdotorg.org>
Date: Mon, 08 Jul 2013 09:51:08 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] ARM: tegra: enable gpio-keys on dalmore
References: <1373102069-5641-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1373102069-5641-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2013 03:14 AM, Laxman Dewangan wrote:
> Dalmore have the keys mounted on board which are connected
> to different pins of Tegra.
> 
> Add the keys entry in DTS file to enable key functionality.
> This will enable KEY_POWER, KEY_HOME, KEY_VOLUMEUP and
> KEY_VOLUMEDOWN.

> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts

> @@ -976,4 +1005,5 @@
>  			 <&tegra_car TEGRA114_CLK_EXTERN1>;
>  		clock-names = "pll_a", "pll_a_out0", "mclk";
>  	};
> +
>  };

What's that? I'll try to remember to fix this up when applying, but
proof-reading would help.
