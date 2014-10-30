Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758754AbaJ3KHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:07:04 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:42594 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135AbaJ3KHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:07:00 -0400
MIME-Version: 1.0
X-Originating-IP: [95.23.101.112]
In-Reply-To: <1413839151-10875-3-git-send-email-javier.martinez@collabora.co.uk>
References: <1413839151-10875-1-git-send-email-javier.martinez@collabora.co.uk>
	<1413839151-10875-3-git-send-email-javier.martinez@collabora.co.uk>
Date: Thu, 30 Oct 2014 11:06:59 +0100
Message-ID: <CABxcv==YZjO9p3aNyuRpe3DYS+=BcY_N2esuTg0hGASb_b_OdA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] ARM: EXYNOS: Call regulator core suspend prepare
 and finish functions
From: Javier Martinez Canillas <javier@dowhile0.org>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>, Mark Brown <broonie@kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kukjin,

On Mon, Oct 20, 2014 at 11:05 PM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> The regulator framework has a set of helpers functions to be used when
> the system is entering and leaving from suspend but these are not called
> on Exynos platforms. This means that the .set_suspend_* function handlers
> defined by regulator drivers are not called when the system is suspended.
>
> Suggested-by: Doug Anderson <dianders@chromium.org>
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Reviewed-by: Doug Anderson <dianders@chromium.org>
> ---
>  arch/arm/mach-exynos/suspend.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>

Any comments on this patch?

Best regards,
Javier
