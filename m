Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517AbaEWWzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 18:55:47 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40592 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaEWWzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 18:55:43 -0400
Message-ID: <537FD1E8.2090705@gmail.com>
Date: Sat, 24 May 2014 00:55:36 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tarek Dakhran <t.dakhran@gmail.com>
CC: Tarek Dakhran <t.dakhran@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Romain Naour <romain.naour@openwide.fr>,
        Chander Kashyap <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v10 1/3] ARM: EXYNOS: Add support for EXYNOS5410 SoC
References: <1400841343-6016-1-git-send-email-t.dakhran@samsung.com>	<1400841343-6016-2-git-send-email-t.dakhran@samsung.com>	<537FB995.5070604@gmail.com>	<CANhyOUd8Q2nzh_bF6LZNuv8keVUB3F45PocYrLP_B=D_Q3tWuQ@mail.gmail.com> <CANhyOUfp1AL6wJ1Q9kWj=v-n9e2CyxkQOPb8_50M5bY_JN2f9A@mail.gmail.com>
In-Reply-To: <CANhyOUfp1AL6wJ1Q9kWj=v-n9e2CyxkQOPb8_50M5bY_JN2f9A@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.05.2014 00:48, Tarek Dakhran wrote:
> Sorry, only now catch it!
> I agree, this patch is not needed anymore, except Kconfig option.
> config SOC_EXYNOS5410 is needed to build clock stuff.

Right, I missed this.

> What is your opinion, Tomasz?
> 

I'd suggest re-spinning this series once more, removing changes that are
not needed anymore, but keeping the Kconfig entry.

Best regards,
Tomasz
