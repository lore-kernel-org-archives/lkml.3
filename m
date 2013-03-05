Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab3CEBp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 20:45:27 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37479 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab3CEBp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 20:45:26 -0500
X-IronPort-AV: E=Sophos;i="4.84,784,1355126400"; 
   d="scan'208";a="27675585"
Message-ID: <51354E35.1080804@codeaurora.org>
Date: Mon, 04 Mar 2013 17:45:25 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Barry Song <baohua.song@csr.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCHv2] ARM: Push selects for TWD/SCU into machine entries
References: <1362007694-3419-1-git-send-email-sboyd@codeaurora.org> <512E9A39.3070207@wwwdotorg.org>
In-Reply-To: <512E9A39.3070207@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/13 15:43, Stephen Warren wrote:
>
> Seems simple enough it doesn't really need many, but for Tegra,
> Acked-by: Stephen Warren <swarren@nvidia.com>
>
> Which kernel is this going into? It's possible Tegra will get converted
> to multi-platform in 3.10, which might move that main ARCH_TEGRA block
> from arch/arm/Kconfig into arch/arm/mach-tegra/Kconfig, although I
> suppose it doesn't /have/ to move it. I think some/all(?) other
> multi-platform conversions have moved their main Kconfig option like
> that though.

Thanks. I'm hoping that Arnd/Olof can pick this up. I'm not sure which
version it will go into.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

