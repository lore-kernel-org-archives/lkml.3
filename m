Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbbAYQFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:05:19 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:35035 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753619AbbAYQFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:05:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Niklas =?ISO-8859-1?Q?S=F6derlund?= <niso@kth.se>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        magnus.damm@gmail.com
Subject: Re: [PATCH v3] sh-pfc: Add emev2 pinmux support
Date: Sun, 25 Jan 2015 18:05:50 +0200
Message-ID: <2863690.d7fDhTIo9u@avalon>
User-Agent: KMail/4.14.3 (Linux/3.17.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1422193792-15970-1-git-send-email-niso@kth.se>
References: <1564701.sT8vso17XV@avalon> <1422193792-15970-1-git-send-email-niso@kth.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Niklas,

Thank you for the patch.

On Sunday 25 January 2015 14:49:52 Niklas Söderlund wrote:
> Add PFC support for the EMMA Mobile EV2 SoC including pin groups for
> on-chip devices.
> 
> Signed-off-by: Niklas Söderlund <niso@kth.se>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  .../bindings/pinctrl/renesas,pfc-pinctrl.txt       |    1 +
>  drivers/pinctrl/sh-pfc/Kconfig                     |    5 +
>  drivers/pinctrl/sh-pfc/Makefile                    |    1 +
>  drivers/pinctrl/sh-pfc/core.c                      |    9 +
>  drivers/pinctrl/sh-pfc/core.h                      |    1 +
>  drivers/pinctrl/sh-pfc/pfc-emev2.c                 | 1711 +++++++++++++++++
>  6 files changed, 1728 insertions(+)
>  create mode 100644 drivers/pinctrl/sh-pfc/pfc-emev2.c

-- 
Regards,

Laurent Pinchart

