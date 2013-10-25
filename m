Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab3JYRNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 13:13:18 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57097 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3JYRNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 13:13:16 -0400
Date: Fri, 25 Oct 2013 12:12:07 -0500
From: Josh Cartwright <joshc@codeaurora.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCHv6 2/4] ARM: msm: Add support for APQ8074 Dragonboard
Message-ID: <20131025171207.GD20207@joshc.qualcomm.com>
References: <1382034310-31147-1-git-send-email-rvaswani@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382034310-31147-1-git-send-email-rvaswani@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Rohit-

On Thu, Oct 17, 2013 at 11:25:10AM -0700, Rohit Vaswani wrote:
> This patch adds basic board support for APQ8074 Dragonboard
> which belongs to the Snapdragon 800 family.
> For now, just support a basic machine with device tree.
> 
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>  arch/arm/boot/dts/Makefile                     |  3 ++-
>  arch/arm/boot/dts/qcom-apq8074-dragonboard.dts |  6 +++++
>  arch/arm/boot/dts/qcom-msm8974.dtsi            | 33 ++++++++++++++++++++++++++
>  arch/arm/mach-msm/Kconfig                      | 11 ++++++++-
>  arch/arm/mach-msm/board-dt.c                   |  9 +++++++
>  5 files changed, 60 insertions(+), 2 deletions(-)
>  create mode 100644 arch/arm/boot/dts/qcom-apq8074-dragonboard.dts
>  create mode 100644 arch/arm/boot/dts/qcom-msm8974.dtsi
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 000cf76..e71a3ec 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -102,7 +102,8 @@ dtb-$(CONFIG_ARCH_KIRKWOOD) += kirkwood-cloudbox.dtb \
>  	kirkwood-openblocks_a6.dtb
>  dtb-$(CONFIG_ARCH_MARCO) += marco-evb.dtb
>  dtb-$(CONFIG_ARCH_MSM) += msm8660-surf.dtb \
> -	msm8960-cdp.dtb
> +	msm8960-cdp.dtb \
> +	qcom-apq8074-dragonboard.dtb

For what it's worth, this hunk conflicts with Kumar's qcom- prefix stuff
that's already been sent up.  Perhaps it's time to refresh ontop?

   Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
