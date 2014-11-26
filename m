Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbaKZQb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:31:58 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:41282 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaKZQb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:31:56 -0500
Message-ID: <54760072.8010307@collabora.co.uk>
Date: Wed, 26 Nov 2014 17:31:46 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
CC: Russell King <linux@arm.linux.org.uk>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH v2 0/5] Fix Arndale Octa/Peach Pi boot on Audio subsystem
 clocks
References: <1417011857-10419-1-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1417011857-10419-1-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 11/26/2014 03:24 PM, Krzysztof Kozlowski wrote:
> Description
> ===========
> This patchset tries to solve dependency between AudioSS components
> (clocks and GPIO) and main clock controller on Exynos platform.
> 
> This solves boot failure of Peach Pi/Pit and Arndale Octa [1].
> 

I tested and patches #2, #3, #4 solves the boot failure I was facing.
So for the whole series on an Exynos5420 Peach Pit:

Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Thanks a lot for solving this issue.

Best regards,
Javier
