Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbaLJQRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 11:17:32 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:54724 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662AbaLJQRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 11:17:30 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, Vivek Gautam <gautam.vivek@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v4 0/3] Fix Arndale Octa/Peach Pi boot on Audio subsystem clocks
References: <1417777254-26579-1-git-send-email-k.kozlowski@samsung.com>
Date: Wed, 10 Dec 2014 08:17:26 -0800
In-Reply-To: <1417777254-26579-1-git-send-email-k.kozlowski@samsung.com>
	(Krzysztof Kozlowski's message of "Fri, 05 Dec 2014 12:00:51 +0100")
Message-ID: <7h4mt3pjhl.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

Krzysztof Kozlowski <k.kozlowski@samsung.com> writes:

> Changes since v3
> ================
> 1. Patch 1/3: Fix issues pointed by Sylwester.
> 2. Add Javier's tested-by [1]

I tested this series on top of next-20141210 (exynos_defconfig and
multi_v7_defconfig) on exynos5800-peach-pi and exynos5420-arndale-octa
it fixes the boot hangs I was seeing with linux-next on those platforms.

Feel free to add:

Tested-by: Kevin Hilman <khilman@linaro.org>

Kevin
