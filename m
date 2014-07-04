Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964833AbaGDM2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 08:28:40 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:33201 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbaGDM2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:28:38 -0400
MIME-Version: 1.0
In-Reply-To: <1401995457-24721-1-git-send-email-andrew.ruder@elecsyscorp.com>
References: <1401995457-24721-1-git-send-email-andrew.ruder@elecsyscorp.com>
Date: Fri, 4 Jul 2014 20:28:31 +0800
Message-ID: <CAN1soZy=SQoPHp1WzS1u5y9a9_7jyvrni5qJvBmLCr=y=szB6g@mail.gmail.com>
Subject: Re: [PATCH] arm: pxa: correct errata number for PXA270
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Andrew Ruder <andrew.ruder@elecsyscorp.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Miao Eric <eric.y.miao@gmail.com>,
        Linux Russell <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 6, 2014 at 3:10 AM, Andrew Ruder
<andrew.ruder@elecsyscorp.com> wrote:
> Comment incorrectly cites errata 39
>     E39. SDIO: SDIO Devices Not Working at 19.5 Mbps
>
> Should be errata 38
>     E38. MEMC: Memory Controller hangs when entering Self Refresh Mode.
>
> Signed-off-by: Andrew Ruder <andrew.ruder@elecsyscorp.com>
> ---
>  arch/arm/mach-pxa/sleep.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-pxa/sleep.S b/arch/arm/mach-pxa/sleep.S
> index 1e544be..6c5b3ff 100644
> --- a/arch/arm/mach-pxa/sleep.S
> +++ b/arch/arm/mach-pxa/sleep.S
> @@ -157,7 +157,7 @@ pxa_cpu_do_suspend:
>         @ Do not reorder...
>         @ Intel PXA270 Specification Update notes problems performing
>         @ external accesses after SDRAM is put in self-refresh mode
> -       @ (see Errata 39 ...hangs when entering self-refresh mode)
> +       @ (see Errata 38 ...hangs when entering self-refresh mode)
>
>         @ force address lines low by reading at physical address 0
>         ldr     r3, [r2]
> --
> 1.9.0.rc3.12.gbc97e2d
>

Acked-by: Haojian Zhuang <haojian.zhuang@gmail.com>
