Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab3K0LOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:14:52 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:52678 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3K0LOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:14:50 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, wsa@the-dreams.de, linus.walleij@linaro.org,
        linux-sh@vger.kernel.org, horms@verge.net.au
Subject: Re: [PATCH] pinctrl: sh-pfc: Initial r7s72100 support
Date: Wed, 27 Nov 2013 12:14:35 +0100
Message-ID: <1976247.WEVz5t99cX@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131127074122.18314.48522.sendpatchset@w520>
References: <20131127074122.18314.48522.sendpatchset@w520>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Wednesday 27 November 2013 16:41:22 Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Add r7s72100 PINCTRL support via sh-pfc. At this point this code
> provides enough support to allow use together with the gpio-rz
> driver. Incremental per-device patches will in the future be
> submitted on top of this base patch to allow PINCTRL enablement
> for each individual device.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  drivers/pinctrl/sh-pfc/Kconfig        |    5
>  drivers/pinctrl/sh-pfc/Makefile       |    1
>  drivers/pinctrl/sh-pfc/core.c         |    9 +
>  drivers/pinctrl/sh-pfc/core.h         |    1
>  drivers/pinctrl/sh-pfc/pfc-r7s72100.c |  166 ++++++++++++++++++++++++++++++

One more comment, you should update the DT bindings documentation with the new 
compatible string.

>  5 files changed, 182 insertions(+)

-- 
Regards,

Laurent Pinchart

