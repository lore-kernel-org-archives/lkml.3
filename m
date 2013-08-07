Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab3HGQiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:38:18 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:15630 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089Ab3HGQiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:38:16 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19IkZD9yhpeZVo/h2yl7OpRDg9DwrBSh1U=
Date: Wed, 7 Aug 2013 12:38:07 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Stepan Moskovchenko <stepanm@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, Lior Amsalem <alior@marvell.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-msm@vger.kernel.org, sboyd@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: dts: Fix memory node in skeleton64.dtsi
Message-ID: <20130807163807.GG19280@titan.lakedaemon.net>
References: <1375839186-1904-1-git-send-email-stepanm@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375839186-1904-1-git-send-email-stepanm@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 06:33:06PM -0700, Stepan Moskovchenko wrote:
> Update the reg property of the memory node in
> skeleton64.dtsi to reflect the fact that the root node uses
> address-cells=2 and size-cells=2.
> 
> Change-Id: Ie9b61166143969e020ceebc51e9a384405d8c0f2
> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
> ---
>  arch/arm/boot/dts/skeleton64.dtsi |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied to mvebu/fixes-non-critical with Gregory's Ack an Change-Id
removed.

thx,

Jason.

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
> -- 
> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
