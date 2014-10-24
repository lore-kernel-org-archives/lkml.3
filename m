Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbaJXNaI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:30:08 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62029 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444AbaJXNaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:30:06 -0400
Message-ID: <544A5459.9020006@gmail.com>
Date: Fri, 24 Oct 2014 15:30:01 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Daniel Drake <drake@endlessm.com>, Chanwoo Choi <cw00.choi@samsung.com>
CC: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>, ben-linux@fluff.org,
        Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Mike Turquette <mturquette@linaro.org>, thomas.abraham@linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        InKi Dae <inki.dae@samsung.com>, geunsik.lim@samsung.com,
        jh80.chung@samsung.com, jaewon02.kim@samsung.com,
        ideal.song@samsung.com, yj44.cho@samsung.com,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 5/5] ARM: dts: Add dts files for Exynos4415 SoC
References: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>	<1413775935-17743-5-git-send-email-cw00.choi@samsung.com> <CAD8Lp46Y1WBF2Bq5SKtQDZ4kUb2fDCsbBs1THFWcV=8-OXh_SQ@mail.gmail.com>
In-Reply-To: <CAD8Lp46Y1WBF2Bq5SKtQDZ4kUb2fDCsbBs1THFWcV=8-OXh_SQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.10.2014 15:23, Daniel Drake wrote:
> On Sun, Oct 19, 2014 at 9:32 PM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patch adds new exynos4415.dtsi to support Exynos4415 SoC
>> based on Cortex-A9 quad cores and includes following dt nodes:
> 
> There's a lot in common between your new exynos4415.dtsi and the
> existing exynos4.dtsi.
> Would it make more sense for the 4415 code to extend the existing
> exynos4.dtsi like the other Exynos4 variants do?

This would make sense, but then existing Exynos 4 device tree sources
would have to be refactored to use reference-based syntax for extending
nodes. (Which is desirable anyway, but adds quite a bit of effort and
could be prone to conflicts.) I'd say that they could be merged later
anyway.

Best regards,
Tomasz
