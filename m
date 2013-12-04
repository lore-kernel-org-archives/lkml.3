Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581Ab3LDKuw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 05:50:52 -0500
Received: from mail-yh0-f52.google.com ([209.85.213.52]:53916 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab3LDKup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 05:50:45 -0500
Date: Wed, 4 Dec 2013 10:50:38 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Milo Kim <milo.kim@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-pwm@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v4 0/4] LP3943 MFD driver for a GPIO expander and a PWM
 generator
Message-ID: <20131204105038.GB907@lee--X1>
References: <1380082975-6022-1-git-send-email-milo.kim@ti.com>
 <20131204103431.GC26589@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131204103431.GC26589@ulmo.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > LP3943 is an integrated device capable of driving 16 output channels.
> > It can be used for GPIO expander and PWM generators.
> > LP3493 registers are controlled via the I2C interface.
> > 
> > This patch-set consists of four parts - MFD, GPIO, PWM and documents.
> > 
> > Update from v3 to v4:
> >   Move the driver description from the documentation to the MFD driver file.
> > 
> > Milo Kim (4):
> >   mfd: add LP3943 MFD driver
> >   gpio: add LP3943 I2C GPIO expander driver
> >   pwm: add LP3943 PWM driver
> >   Documentation: add LP3943 DT bindings and document
> 
> I suspect that given the build-time dependencies Lee may want to take
> all four patches through the MFD tree, so I've acked the PWM parts.

Thanks Thierry.

Milo, would you mind re-sending the patch-set complete with
Thierry's Acks please? Also, can you send [PATCH 1/X]..[PATCH X/X] as
replies to [PATCH 0/X], as it aids greatly with status tracking.

Please see git send-email options:
  `--[no-]thread` and `--[no-]chain-reply-to`

For shallow threading, which is what I believe you want, you need:
  `--thread --no-chain-reply-to`

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
