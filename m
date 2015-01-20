Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753851AbbATRyP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:54:15 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:40996 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbbATRyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:54:13 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "Javier Martinez Canillas" <javier.martinez@collabora.co.uk>,
        "Kukjin Kim" <kgene@kernel.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <54BE6050.1090205@samsung.com>
Cc: "Tomasz Figa" <tomasz.figa@gmail.com>,
        "Rahul Sharma" <rahul.sharma@samsung.com>,
        "Arun Kumar K" <arun.kk@samsung.com>,
        "Doug Anderson" <dianders@chromium.org>,
        "Olof Johansson" <olof@lixom.net>,
        "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Tobias Jakobi" <liquid.acid@gmx.net>,
        "Andrzej Hajda" <a.hajda@samsung.com>,
        "Krzysztof Kozlowski" <k.kozlowski@samsung.com>,
        "Kevin Hilman" <khilman@linaro.org>,
        "Joonyoung Shim" <jy0922.shim@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1421750127-22536-1-git-send-email-javier.martinez@collabora.co.uk>
 <1421750127-22536-2-git-send-email-javier.martinez@collabora.co.uk>
 <54BE6050.1090205@samsung.com>
Message-ID: <20150120175402.22722.84342@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 1/2] clk: exynos5420: Add IDs for clocks used in DISP1 power
 domain
Date: Tue, 20 Jan 2015 09:54:02 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sylwester Nawrocki (2015-01-20 06:04:00)
> Hi,
> 
> On 20/01/15 11:35, Javier Martinez Canillas wrote:
> > When a power domain is powered off on Exynos5420 SoC, the input clocks of
> > the devices attached to this power domain are re-parented to oscclk and
> > restored to the original parent after powering on the power domain.
> > 
> > So a reference to the input and parent clocks for the devices attached to
> > a power domain are needed to be able to do the re-parenting. The DISP1 pd
> > includes modules which uses the following clocks:
> > 
> > ACLK_200_DISP1 (MIXER and HDMILINK)
> > ACLK_300_DISP1 (FIMD1)
> > ACLK_400_DISP1 (Internal Buses)
> > 
> > Each of these clocks are generated as the output of a clock mux so add an
> > ID for all of these clock muxes and their parents to be referenced in the
> > DISP1 power domain device node.
> > 
> > Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> 
> The patch looks OK to me, I'm fine with it being merged via Kukjin's tree
> due to the dts dependencies (including other pending dts patches touching
> the arch/arm/boot/dts/exynos5420.dtsi file).
> I think we need also Mike ACK for that, I could also queue the patch for
> the clk tree and create a topic branch, but merging both patches via
> arm-soc seems a more sane option in this case.
> 
> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Acked-by: Michael Turquette <mturquette@linaro.org>

> 
> --
> Thanks,
> Sylwester
> 
