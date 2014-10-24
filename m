Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597AbaJXNSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 09:18:24 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:54127 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756437AbaJXNSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 09:18:22 -0400
MIME-Version: 1.0
In-Reply-To: <1413775935-17743-2-git-send-email-cw00.choi@samsung.com>
References: <1413775749-17539-1-git-send-email-cw00.choi@samsung.com>
	<1413775935-17743-2-git-send-email-cw00.choi@samsung.com>
Date: Fri, 24 Oct 2014 07:18:21 -0600
Message-ID: <CAD8Lp45F_6UWXx0f2xVGZL+Rgemg2fzkYhnfPdaeaiky0rKPgw@mail.gmail.com>
Subject: Re: [PATCH 2/5] clk: samsung: exynos4415: Add clocks using common
 clock framework
From: Daniel Drake <drake@endlessm.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
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
        ideal.song@samsung.com, yj44.cho@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 19, 2014 at 9:32 PM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> This patch adds the new clock driver of Exynos4415 SoC based on Cortex-A9
> using common clock framework. The CMU (Clock Management Unit) of Exynos4415
> controls PLLs(Phase Locked Loops) and generates system clocks for CPU, buses
> and function clocks for individual IPs.

There seems to be a lot in common here with other exynos4 variants in
clk-exynos4.c. Have you considered just adding support for the 4415 in
the existing driver?

Thanks
Daniel
