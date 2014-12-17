Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaLQOgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 09:36:49 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:58704 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaLQOgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 09:36:47 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Eddie Huang <eddie.huang@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        srv_heupstream@mediatek.com, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Brown <broonie@linaro.org>, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, Robert Richter <rrichter@cavium.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Olof Johansson <olof@lixom.net>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 0/4] Add basic support for Mediatek MT8173 SoC
Date: Wed, 17 Dec 2014 15:35:35 +0100
Message-ID: <1808813.15ih7rDt4r@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1418825853-10934-1-git-send-email-eddie.huang@mediatek.com>
References: <1418825853-10934-1-git-send-email-eddie.huang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:ATJhBGLF6zXxwJ9ZNdhS6vfWS3m9qU22Q8VoIfW8wHjbVGI3PQQ
 SDSMwug5ZucgtVM+mcSisyHddGJJftJqeg2AzCUw9rXMddRBJnKCvAQw0VMgsYqekJ8kXGg
 CBEIY3F3J4gvLRrBV5hLquu1kk0++BMB/zdqw/1QFy1s+ljwmCDFcmjz+VkQKSsfuhtrTUF
 l//HKjqYDLu/7f72Mysaw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 December 2014 22:17:29 Eddie Huang wrote:
> MT8173 is a SoC based on 64bit ARMv8 architecture. It contains 2 CA53 + 2 CA57 cores. MT8173 share many HW IP with MT8135 and other MT65xx series. This patchset was tested on MT8173 engineer sample, and boot to shell ok.
> 
> This series contains document bindings, device tree, defconfig, and one sysirq modification for MT8173.
> 
> Changes in v2:
> 
> 1. Modify mt8173.dtsi and mt8173-evb.dts according to Mark Rutland's comment, change cpu-maps, psci, clock, GIC properties.
> 2. Modify irq-mtk-sysirq.c according to Arnd Bergmann's comment to calculate irq number from reg range.
> 
> 

Looks good to me,

Acked-by: Arnd Bergmann <arnd@arndb.de>

In the 3.19 merge window, we had a few problems with new arm64 platforms,
as it wasn't entirely clear to us who is a maintainer and whether patches
were sent for review or inclusion. I see no problem including your series
in 3.20, but we probably need to figure out the best process for making
sure we don't miss it.

For now, I'd suggest we do this the same way as the arm32 patches, and
you send them to Matthias for inclusion in his tree, who will then
send a pull request for an arm64 branch.

	Arnd
