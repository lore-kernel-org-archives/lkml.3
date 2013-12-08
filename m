Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759767Ab3LHSqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 13:46:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56978 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab3LHSqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 13:46:12 -0500
Message-ID: <52A4BE72.1080005@infradead.org>
Date: Sun, 08 Dec 2013 10:46:10 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] [trivial] treewide: Fix typo in printk
References: <1386516173-1939-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1386516173-1939-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/13 07:22, Masanari Iida wrote:
> Correct spelling typo in various part of kernel
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.


> ---
>  arch/arm/mach-imx/mach-pca100.c               | 2 +-
>  arch/arm64/kvm/handle_exit.c                  | 2 +-
>  arch/mips/ralink/cevt-rt3352.c                | 2 +-
>  arch/mips/ralink/timer.c                      | 2 +-
>  arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c | 2 +-
>  drivers/char/msm_smd_pkt.c                    | 2 +-
>  drivers/devfreq/exynos/exynos5_bus.c          | 2 +-
>  drivers/gpu/drm/exynos/exynos_drm_fimc.c      | 2 +-
>  drivers/gpu/drm/exynos/exynos_drm_gsc.c       | 4 ++--
>  drivers/i2c/busses/i2c-exynos5.c              | 2 +-
>  drivers/iio/adc/twl6030-gpadc.c               | 2 +-
>  drivers/isdn/hisax/hfc4s8s_l1.c               | 2 +-
>  drivers/media/platform/ti-vpe/vpdma.c         | 4 ++--
>  drivers/net/wireless/libertas/cmdresp.c       | 2 +-
>  drivers/video/udlfb.c                         | 2 +-
>  fs/btrfs/tests/free-space-tests.c             | 2 +-
>  net/nfc/digital_dep.c                         | 2 +-
>  17 files changed, 19 insertions(+), 19 deletions(-)


-- 
~Randy
