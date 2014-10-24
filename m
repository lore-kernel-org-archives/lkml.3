Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831AbaJXNoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:44:25 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33329 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639AbaJXNoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:44:22 -0400
MIME-Version: 1.0
In-Reply-To: <544A5578.7030009@samsung.com>
References: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
	<1413775935-17743-5-git-send-email-cw00.choi@samsung.com>
	<CAD8Lp46Y1WBF2Bq5SKtQDZ4kUb2fDCsbBs1THFWcV=8-OXh_SQ@mail.gmail.com>
	<544A5578.7030009@samsung.com>
Date: Fri, 24 Oct 2014 07:44:21 -0600
Message-ID: <CAD8Lp45thqGRm-SjFnnht1EGuFYWabG_D9vWUQt+NnCcgVG7bg@mail.gmail.com>
Subject: Re: [PATCH 5/5] ARM: dts: Add dts files for Exynos4415 SoC
From: Daniel Drake <drake@endlessm.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>, ben-linux@fluff.org,
        Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, thomas.abraham@linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        InKi Dae <inki.dae@samsung.com>, geunsik.lim@samsung.com,
        jh80.chung@samsung.com, jaewon02.kim@samsung.com,
        ideal.song@samsung.com, yj44.cho@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 7:34 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Well, I also thought about such approach, but there are some fundamental
> differences:
> interrupt and clock controllers are completely different. Using a common
> exynos4.dtsi
> and overriding them in every node will result in a code, which is a bit hard
> to follow.
> IMHO with such differences justifies using separate base dtsi file.

For the things that aren't in common, they are already split out into
soc-specific files for the existing Exynos4 variants. Taking your
example of the CMU, it already differs in different exynos4 versions
therefore is not listed in exynos4.dtsi at all.

So this argument only seems valid if the differences are really huge,
or if you are also saying the existing exynos4 dts files are bad?
Personally I have come to like the current layout, although would
definitely appreciate the reference-based syntax mentioned by Tomasz,
and this seems like a good opportunity to at least fix up exynos4.dtsi
for that.

Daniel
