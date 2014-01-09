Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbaAIJ3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 04:29:31 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:38278 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811AbaAIJ31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:29:27 -0500
MIME-Version: 1.0
In-Reply-To: <1389243595-13207-1-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-5-git-send-email-ch.naveen@samsung.com>
	<1389243595-13207-1-git-send-email-ch.naveen@samsung.com>
Date: Thu, 9 Jan 2014 14:59:26 +0530
Message-ID: <CAK9yfHyya0LwYp0f2ZrBbb9M51FVxnBkZuHqrD1ju9yDBffmqg@mail.gmail.com>
Subject: Re: [PATCH 4/6 v2] crypto:s5p-sss: Kconfig: Let Exynos SoCs select
 SSS driver
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-crypto@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, vzapolskiy@gmail.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On 9 January 2014 10:29, Naveen Krishna Chatradhi <ch.naveen@samsung.com> wrote:
> From: Naveen Krishna Ch <ch.naveen@samsung.com>
>
> This patch modifies Kconfig such that ARCH_EXYNOS SoCs
> which includes (Exynos4210, Exynos5250 and Exynos5420)
> can also select Samsung SSS(Security SubSystem) driver.

What about Exynos4x12 and 5440 as they too come under ARCH_EXYNOS?

-- 
With warm regards,
Sachin
