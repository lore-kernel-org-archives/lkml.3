Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbaESKvu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 06:51:50 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:59671 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753514AbaESKvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 06:51:46 -0400
Message-ID: <5379E238.1080803@gmail.com>
Date: Mon, 19 May 2014 12:51:36 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tarek Dakhran <t.dakhran@samsung.com>, linux-kernel@vger.kernel.org
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
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
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Tarek Dakhran <t.dakhran@gmail.com>
Subject: Re: [PATCH v9 0/3] Exynos 5410 support
References: <1400470640-30611-1-git-send-email-t.dakhran@samsung.com>
In-Reply-To: <1400470640-30611-1-git-send-email-t.dakhran@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tarek,

On 19.05.2014 05:37, Tarek Dakhran wrote:
> The series of patches represent support of Exynos 5410 SoC
> 
> The Exynos 5410 is the first Samsung SoC based on big.LITTLE architecture
> 
> Patches add new platform description, support of clock controller and device
> tree for Exynos 5410.
> 
> Has been build on Samsung Linux Kernel
>   (branch: for-next, commit: ccf5511 ARM: EXYNOS: Add MCPM call-back functions)

This doesn't look like an up-to-date tip of that branch. There was a lot
of changes merged 2 days ago, especially from samsung-clk tree and your
patches won't apply and/or compile (at least patch 2/3). Are you sure
you didn't have a git fetch error?

Moreover I can still see the dts using full-path syntax, instead of
reference-based one and also no soc node, as I pointed in v8. [1]

[1] https://lkml.org/lkml/2014/4/26/59

Another thing is that I still see a custom fixed clock binding being
used for oscclk in the clock driver, while I believe I pointed in some
of the previous versions that generic fixed clock should be used.

Best regards,
Tomasz
