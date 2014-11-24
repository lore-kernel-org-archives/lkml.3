Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbaKXR27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:28:59 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38562 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbaKXR26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:28:58 -0500
Message-ID: <54736AD0.4070909@collabora.co.uk>
Date: Mon, 24 Nov 2014 18:28:48 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Kevin Hilman <khilman@kernel.org>
Subject: Re: [RFC 0/2] Fix Arndale Octa/Peach Pi boot on Audio subsystem clocks
References: <1416842312-4405-1-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1416842312-4405-1-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 11/24/2014 04:18 PM, Krzysztof Kozlowski wrote:
> Hi,
> 
> 
> This is initial idea to solve dependency between AudioSS clocks
> and main clock controller on Exynos platform.
> 
> This solves boot failure of Peach Pi/Pit and Arndale Octa [1].
> 

I tested this series on an Exynos5420 Peach Pit but I still
have the boot hang so it doesn't solve the issue on this board.

I'm using linux-next + your patches with exynos_defconfig and
without the clk_ignore_unused command line parameter.

Best regards,
Javier
