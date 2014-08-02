Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbaHBKlp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 06:41:45 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:33419 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750851AbaHBKln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 06:41:43 -0400
Date: Sat, 2 Aug 2014 11:41:34 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        linux-samsung-soc@vger.kernel.org, Tomasz Figa <t.figa@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sachin Kamat <sachin.kamat@samsung.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 1/2] ARM: EXYNOS: Fix build with PM_SLEEP=n part #2
Message-ID: <20140802104134.GA30282@n2100.arm.linux.org.uk>
References: <1405349040-5265-1-git-send-email-b.zolnierkie@samsung.com> <1405349040-5265-2-git-send-email-b.zolnierkie@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405349040-5265-2-git-send-email-b.zolnierkie@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 04:43:59PM +0200, Bartlomiej Zolnierkiewicz wrote:
> Fix building of exynos_defconfig with disabled CONFIG_PM_SLEEP by
> adding checking whether Exynos cpuidle support is enabled before
> accessing exynos_enter_aftr.
> 
> The build error message:
> arch/arm/mach-exynos/built-in.o:(.data+0x74): undefined reference to `exynos_enter_aftr'
> make: *** [vmlinux] Error 1
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

What's happening with this patch?  I'm still seeing failures in my builds
due to the above error from Tuesday's arm-soc.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
