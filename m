Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3KTK5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 05:57:49 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:57008 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab3KTK5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 05:57:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        horms@verge.net.au
Subject: Re: [PATCH 00/05] gpio: R-Car and EM GPIO update V2
Date: Wed, 20 Nov 2013 11:58:32 +0100
Message-ID: <18469590.Iog5Xntpc3@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131120002259.27342.35575.sendpatchset@w520>
References: <20131120002259.27342.35575.sendpatchset@w520>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

Thank you for the patch.

On Wednesday 20 November 2013 09:22:59 Magnus Damm wrote:
> gpio: R-Car and EM GPIO update V2
> 
> [PATCH 01/05 v2] gpio: rcar: Use lazy disable
> [PATCH 02/05 v2] gpio: rcar: Enable mask on suspend
> [PATCH 03/05] gpio: em: Setup gpiochip->dev
> [PATCH 04/05 v2] gpio: em: Use lazy disable
> [PATCH 05/05 v2] gpio: em: Enable mask on suspend
> 
> Update the R-Car GPIO driver and the GPIO driver used on EMEV2 to use lazy
> disable and mask on suspend. This fixes the Suspend-to-RAM behavior to make
> sure wakeup sources are left enabled while suspending. Also include a small
> fix for gpio-em that fixes the DT use case.
> 
> Thanks to Laurent and Linus for feedback.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>

For the whole series,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> 
>  Written against renesas.git tag renesas-devel-v3.12-20131119
> 
>  Changes since V1:
>  - Split lazy disable and mask on suspend patches
>  - Improved commit messages
> 
>  drivers/gpio/gpio-em.c   |    5 ++---
>  drivers/gpio/gpio-rcar.c |    5 ++---
>  2 files changed, 4 insertions(+), 6 deletions(-)
-- 
Regards,

Laurent Pinchart

