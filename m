Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab3ETPLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:11:21 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:55113 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3ETPLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 11:11:19 -0400
MIME-Version: 1.0
In-Reply-To: <519A3A5D.6090703@digi.com>
References: <5196375A.1070308@digi.com>
	<519639A5.9070807@freescale.com>
	<519A3A5D.6090703@digi.com>
Date: Mon, 20 May 2013 12:11:18 -0300
Message-ID: <CAOMZO5BaHRDjomihd-_4-5g8peEwLGkQh0MtqEKqDfV-YnDk+g@mail.gmail.com>
Subject: Re: mxsfb on i.MX28 uses bypassed ref_xtal 24MHz clock for LCD
From: Fabio Estevam <festevam@gmail.com>
To: Hector Palacios <hector.palacios@digi.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Vasut <marex@denx.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 11:59 AM, Hector Palacios
<hector.palacios@digi.com> wrote:

> Agh. Now it works on the EVK. I had something wrong with the backlight
> (maybe a bad DTB).
>
> Do you have any comment on the fact that the lcdif clock is bypassed to the
> 24MHz ref clock? Doesn't this make useless the definition of pixelclk for
> the different displays in mach-mxs.c?
> You can only obtain whole divisors of this frequency (24, 12, 6, 4), which
> may not be accurate enough to fit some displays.

I haven't had a chance to look at it yet, but feel free to submit
patches if you think you can improve the driver.

Thanks,

Fabio Estevam
