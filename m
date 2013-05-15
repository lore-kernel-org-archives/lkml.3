Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab3EOMEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:04:51 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:40540 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414Ab3EOMEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:04:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Sekhar Nori <nsekhar@ti.com>, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/6] ARM: davinci: dm365 evm: remove init_enable from ths7303 pdata
Date: Wed, 15 May 2013 14:05:07 +0200
Message-ID: <1928313.pnnBGKgv0p@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo-r1; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1368619042-28252-3-git-send-email-prabhakar.csengg@gmail.com>
References: <1368619042-28252-1-git-send-email-prabhakar.csengg@gmail.com> <1368619042-28252-3-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thank you for the patch.

On Wednesday 15 May 2013 17:27:18 Lad Prabhakar wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> remove init_enable from ths7303 pdata as it is no longer exists.

You should move this before 1/6, otherwise you will break bisection.

> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: linux-kernel@vger.kernel.org
> Cc: davinci-linux-open-source@linux.davincidsp.com
> Cc: linux-arm-kernel@lists.infradead.org
> ---
>  arch/arm/mach-davinci/board-dm365-evm.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c
> b/arch/arm/mach-davinci/board-dm365-evm.c index 2a66743..4e02ae7 100644
> --- a/arch/arm/mach-davinci/board-dm365-evm.c
> +++ b/arch/arm/mach-davinci/board-dm365-evm.c
> @@ -510,7 +510,6 @@ struct ths7303_platform_data ths7303_pdata = {
>  	.ch_1 = 3,
>  	.ch_2 = 3,
>  	.ch_3 = 3,
> -	.init_enable = 1,
>  };
> 
>  static struct amp_config_info vpbe_amp = {
-- 
Regards,

Laurent Pinchart

