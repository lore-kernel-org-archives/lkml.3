Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124Ab3EMCHu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:07:50 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36393 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab3EMCHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:07:48 -0400
MIME-Version: 1.0
In-Reply-To: <1367803801-17111-2-git-send-email-chao.xie@marvell.com>
References: <1367803801-17111-1-git-send-email-chao.xie@marvell.com> <1367803801-17111-2-git-send-email-chao.xie@marvell.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 13 May 2013 10:07:26 +0800
Message-ID: <CAMPhdO_YX+uZ=MrNbz0_pY67zfvomOqK63z8E_PBoGG4XCO0tA@mail.gmail.com>
Subject: Re: [PATCH V4 1/3] pwm: pxa: ARCH_MMP share same pwm driver with ARCH_PXA
To: Chao Xie <chao.xie@marvell.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Chao Xie <xiechao.mail@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 9:29 AM, Chao Xie <chao.xie@marvell.com> wrote:
> The PWM driver is not only used by ARCH_PXA but also ARCH_MMP.
>
> Signed-off-by: Chao Xie <chao.xie@marvell.com>

Looks good to me.

Acked-by: Eric Miao <eric.y.miao@gmail.com>

> ---
>  drivers/pwm/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 115b644..9ec4040 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -108,7 +108,7 @@ config PWM_PUV3
>
>  config PWM_PXA
>         tristate "PXA PWM support"
> -       depends on ARCH_PXA
> +       depends on ARCH_PXA || ARCH_MMP
>         help
>           Generic PWM framework driver for PXA.
>
> --
> 1.7.4.1
>
