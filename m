Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab3CTUsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:48:51 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54725 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3CTUst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:48:49 -0400
Message-ID: <514A20AE.9040604@wwwdotorg.org>
Date: Wed, 20 Mar 2013 14:48:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 3/4] ARM: tegra: dalmore: add dt node for TPS65090's regulators
References: <1363787070-14801-1-git-send-email-ldewangan@nvidia.com> <1363787070-14801-4-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1363787070-14801-4-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 07:44 AM, Laxman Dewangan wrote:
> NVIDIA's Tegra114 platform, Dalmore, uses the TPS65090 as
> secondary PMICs which mainly act as voltage switch controlled
> by I2C communication.

> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts

> @@ -747,4 +823,18 @@
>  		bus-width = <8>;
>  		status = "okay";
>  	};
> +	regulators {
> +		compatible = "simple-bus";
> +		#address-cells = <1>;

You need a blank line between the nodes there.

There a a number of typos and capitalization issues in the various
commit descriptions.
