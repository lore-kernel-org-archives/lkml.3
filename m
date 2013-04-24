Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab3DXSzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 14:55:48 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:45183 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756367Ab3DXSzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 14:55:46 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        SH-Linux <linux-sh@vger.kernel.org>, linux-leds@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 3/9] pwm: Add Renesas Mobile TPU PWM driver
Date: Wed, 24 Apr 2013 20:55:45 +0200
Message-ID: <4234281.i4nY8H6pM1@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <CANqRtoQzuBg7Y=zPGPDfmWzKjuR8nGfgEgK43+7uSdivmyaBjg@mail.gmail.com>
References: <1366761969-16759-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1366761969-16759-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CANqRtoQzuBg7Y=zPGPDfmWzKjuR8nGfgEgK43+7uSdivmyaBjg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

Thanks for the review.

On Wednesday 24 April 2013 18:37:57 Magnus Damm wrote:
> On Wed, Apr 24, 2013 at 1:06 AM, Laurent Pinchart wrote:
> > The Timer Pulse Unit (TPU is a 4-channels 16-bit timer used to generate
> > waveforms. This driver exposes PWM functions through the PWM API for
> > other drivers to use.
> > 
> > The code is loosely based on the leds-renesas-tpu driver by Magnus Damm
> > and the TPU PWM driver shipped in the Armadillo EVA 800 kernel sources.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > Tested-by: Simon Horman <horms@verge.net.au>
> > ---
> > 
> >  drivers/pwm/Kconfig                    |   7 +
> >  drivers/pwm/Makefile                   |   1 +
> >  drivers/pwm/pwm-rmob.c                 | 462 ++++++++++++++++++++++++++++
> >  include/linux/platform_data/pwm-rmob.h |  18 ++
> >  4 files changed, 488 insertions(+)
> >  create mode 100644 drivers/pwm/pwm-rmob.c
> >  create mode 100644 include/linux/platform_data/pwm-rmob.h
> 
> Thanks for your efforts with this driver. The new code becomes much nicer
> compared to my old driver.
> 
> The TPU hardware block is used across several different Renesas product
> lines, including R-Mobile and R-Car. So with that in mind, can you please
> consider renaming this driver?
> 
> I propose pwm-renesas-tpu.c or pwm-tpu.c instead of pwm-rmob.c. This
> because this driver has nothing to do with the R mobile product line.

pwm-renesas-tpu.c sounds good. I'll rename the driver accordingly and will 
resubmit the patch set.

-- 
Regards,

Laurent Pinchart

