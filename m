Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab3HGGXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:23:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57859 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754861Ab3HGGXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:23:12 -0400
Message-ID: <5201E7CA.4050601@free-electrons.com>
Date: Wed, 07 Aug 2013 08:23:06 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Stepan Moskovchenko <stepanm@codeaurora.org>
CC: Russell King <linux@arm.linux.org.uk>, Lior Amsalem <alior@marvell.com>,
        Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, sboyd@codeaurora.org
Subject: Re: [PATCH] ARM: dts: Fix memory node in skeleton64.dtsi
References: <1375839186-1904-1-git-send-email-stepanm@codeaurora.org>
In-Reply-To: <1375839186-1904-1-git-send-email-stepanm@codeaurora.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 03:33, Stepan Moskovchenko wrote:
> Update the reg property of the memory node in
> skeleton64.dtsi to reflect the fact that the root node uses
> address-cells=2 and size-cells=2.

Good catch

Acked-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

> 
> Change-Id: Ie9b61166143969e020ceebc51e9a384405d8c0f2
> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
> ---
>  arch/arm/boot/dts/skeleton64.dtsi |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/skeleton64.dtsi b/arch/arm/boot/dts/skeleton64.dtsi
> index 1599415..b5d7f36 100644
> --- a/arch/arm/boot/dts/skeleton64.dtsi
> +++ b/arch/arm/boot/dts/skeleton64.dtsi
> @@ -9,5 +9,5 @@
>  	#size-cells = <2>;
>  	chosen { };
>  	aliases { };
> -	memory { device_type = "memory"; reg = <0 0>; };
> +	memory { device_type = "memory"; reg = <0 0 0 0>; };
>  };
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
