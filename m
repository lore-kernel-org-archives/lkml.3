Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaEWVPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:15:47 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:63873 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbaEWVPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:15:45 -0400
Message-ID: <537FBA7A.3000605@gmail.com>
Date: Fri, 23 May 2014 23:15:38 +0200
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
Subject: Re: [PATCH v10 3/3] ARM: dts: Add initial device tree support for
 EXYNOS5410
References: <1400841343-6016-1-git-send-email-t.dakhran@samsung.com> <1400841343-6016-4-git-send-email-t.dakhran@samsung.com>
In-Reply-To: <1400841343-6016-4-git-send-email-t.dakhran@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tarek,

On 23.05.2014 12:35, Tarek Dakhran wrote:
> Add initial device tree nodes for EXYNOS5410 SoC and SMDK5410 board.
> 
> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
> ---
>  arch/arm/boot/dts/Makefile                |    1 +
>  arch/arm/boot/dts/exynos5410-smdk5410.dts |   82 ++++++++++++
>  arch/arm/boot/dts/exynos5410.dtsi         |  206 +++++++++++++++++++++++++++++
>  3 files changed, 289 insertions(+)
>  create mode 100644 arch/arm/boot/dts/exynos5410-smdk5410.dts
>  create mode 100644 arch/arm/boot/dts/exynos5410.dtsi

Looks good. Hopefully we can have this patch applied soon, so it won't
get outdated again.

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
