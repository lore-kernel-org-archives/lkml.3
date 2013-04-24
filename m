Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab3DXRiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 13:38:02 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:46644 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091Ab3DXRiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 13:38:00 -0400
MIME-Version: 1.0
In-Reply-To: <1366761969-16759-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1366761969-16759-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
	<1366761969-16759-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Wed, 24 Apr 2013 18:37:57 +0100
Message-ID: <CANqRtoQzuBg7Y=zPGPDfmWzKjuR8nGfgEgK43+7uSdivmyaBjg@mail.gmail.com>
Subject: Re: [PATCH 3/9] pwm: Add Renesas Mobile TPU PWM driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: SH-Linux <linux-sh@vger.kernel.org>, linux-leds@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Wed, Apr 24, 2013 at 1:06 AM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:
> The Timer Pulse Unit (TPU is a 4-channels 16-bit timer used to generate
> waveforms. This driver exposes PWM functions through the PWM API for
> other drivers to use.
>
> The code is loosely based on the leds-renesas-tpu driver by Magnus Damm
> and the TPU PWM driver shipped in the Armadillo EVA 800 kernel sources.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Tested-by: Simon Horman <horms@verge.net.au>
> ---
>  drivers/pwm/Kconfig                    |   7 +
>  drivers/pwm/Makefile                   |   1 +
>  drivers/pwm/pwm-rmob.c                 | 462 +++++++++++++++++++++++++++++++++
>  include/linux/platform_data/pwm-rmob.h |  18 ++
>  4 files changed, 488 insertions(+)
>  create mode 100644 drivers/pwm/pwm-rmob.c
>  create mode 100644 include/linux/platform_data/pwm-rmob.h

Thanks for your efforts with this driver. The new code becomes much
nicer compared to my old driver.

The TPU hardware block is used across several different Renesas
product lines, including R-Mobile and R-Car. So with that in mind, can
you please consider renaming this driver?

I propose pwm-renesas-tpu.c or pwm-tpu.c instead of pwm-rmob.c. This
because this driver has nothing to do with the R mobile product line.

Thanks,

/ magnus
