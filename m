Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab3L2XfA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Dec 2013 18:35:00 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:35139 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3L2Xe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Dec 2013 18:34:58 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, wsa@the-dreams.de, linus.walleij@linaro.org,
        linux-sh@vger.kernel.org, horms@verge.net.au
Subject: Re: [PATCH 00/05 v2] pinctrl: sh-pfc: r7s72100 support V2
Date: Mon, 30 Dec 2013 00:35:27 +0100
Message-ID: <3087157.CQigdn8Dqq@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131217023745.24573.3660.sendpatchset@w520>
References: <20131217023745.24573.3660.sendpatchset@w520>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

I have pending PFC patches for v3.14. Do you plan to resubmit this series with 
the problem pointed out by Wolfram fixed for v3.14, or will you push it back 
to v3.15 ?

On Tuesday 17 December 2013 11:37:45 Magnus Damm wrote:
> pinctrl: sh-pfc: r7s72100 support V2
> 
> [PATCH 01/05 v2] pinctrl: sh-pfc: Rework _GP_GPIO, introduce _GP_GPIO32
> [PATCH 02/05 v2] pinctrl: sh-pfc: r7s72100 base support
> [PATCH 03/05 v2] pinctrl: sh-pfc: r7s72100 single pin macros
> [PATCH 04/05 v2] pinctrl: sh-pfc: r7s72100 SCIF support
> [PATCH 05/05 v2] pinctrl: sh-pfc: r8a7791 and r7s72100 binding docs
> 
> This is V2 of r7s72100 PFC support. Included this time is:
> - Some slight rework of shared sh-pfc macros
> - Complete r7s72100 SCIF support
> - Binding documentation
> 
> If you prefer me to adjust this code somehow then please let me know.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  Written against renesas.git tag renesas-devel-v3.13-rc3-20131214v2
> 
>  Documentation/devicetree/bindings/pinctrl/renesas,pfc-pinctrl.txt |    2
>  drivers/pinctrl/sh-pfc/Kconfig                                    |    5
>  drivers/pinctrl/sh-pfc/Makefile                                   |    1
>  drivers/pinctrl/sh-pfc/core.c                                     |    9
>  drivers/pinctrl/sh-pfc/core.h                                     |    1
>  drivers/pinctrl/sh-pfc/pfc-r7s72100.c                             |  340 ++
>  drivers/pinctrl/sh-pfc/sh_pfc.h                                   |    9
>  7 files changed, 363 insertions(+), 4 deletions(-)

-- 
Regards,

Laurent Pinchart

