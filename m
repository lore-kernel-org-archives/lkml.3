Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676AbaJGMbD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:31:03 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:64756 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaJGMbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:31:00 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.101.112]
In-Reply-To: <1412587602-7763-3-git-send-email-pankaj.dubey@samsung.com>
References: <1412587602-7763-1-git-send-email-pankaj.dubey@samsung.com>
	<1412587602-7763-3-git-send-email-pankaj.dubey@samsung.com>
Date: Tue, 7 Oct 2014 14:30:59 +0200
Message-ID: <CABxcv=mWCDh2esb6c0Y4pLy70RUrhwZxBiarKNOoxD+gC3gLfw@mail.gmail.com>
Subject: Re: [PATCH v9 2/2] ARM: EXYNOS: Move PMU specific definitions from common.h
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vikas Sajjan <vikas.sajjan@samsung.com>, naushad@samsung.com,
        thomas.ab@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pankaj,

On Mon, Oct 6, 2014 at 11:26 AM, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
> This patch moves PMU specific definitions into a new file
> as exynos-pmu.h.
> This will help in reducing dependency of common.h in pmu.c.
>
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  arch/arm/mach-exynos/common.h     |   17 -----------------
>  arch/arm/mach-exynos/exynos-pmu.h |   24 ++++++++++++++++++++++++
>  arch/arm/mach-exynos/pm.c         |    1 +
>  arch/arm/mach-exynos/pmu.c        |   20 +++++++++++++++++++-
>  arch/arm/mach-exynos/suspend.c    |    1 +
>  5 files changed, 45 insertions(+), 18 deletions(-)
>  create mode 100644 arch/arm/mach-exynos/exynos-pmu.h
>

Tested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>

Best regards,
Javier
