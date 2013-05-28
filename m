Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934765Ab3E1QGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 12:06:53 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:57523 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934630Ab3E1QGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 12:06:51 -0400
MIME-Version: 1.0
In-Reply-To: <39428ed7f69bd06e3d93f730ba8f7b7b0a3f6c26.1369083628.git.chr.ohm@gmx.net>
References: <cover.1369083628.git.chr.ohm@gmx.net>
	<39428ed7f69bd06e3d93f730ba8f7b7b0a3f6c26.1369083628.git.chr.ohm@gmx.net>
Date: Tue, 28 May 2013 19:06:47 +0300
Message-ID: <CAHp75Ve6KQXiuD_XRr2+CUVZNHdjCniJdxDGParpOTopmWxMaw@mail.gmail.com>
Subject: Re: [PATCH 1/2] HID: Add driver for Holtek gaming mouse 04d9:a067
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Christian Ohm <chr.ohm@gmx.net>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 2:31 AM, Christian Ohm <chr.ohm@gmx.net> wrote:
> This mouse is sold as Sharkoon Drakonia and Perixx MX-2000 and reports a
> too high usage maximum and logical maximum. This driver fixes the report
> descriptor so those values don't exceed HID_MAX_USAGES.

Patch is already applied, but I think it worth to go through my
nitpicks as well.

> +++ b/drivers/hid/hid-holtek-mouse.c
> @@ -0,0 +1,72 @@
> +/*
> + * HID driver for Holtek gaming mice
> + * Copyright (c) 2013 Christian Ohm
> + * Heavily inspired by various other HID drivers that adjust the report
> + * descriptor.
> +*/
> +
> +/*

There is no need to break comments here.

> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + */

> +module_exit(holtek_mouse_exit);
> +module_init(holtek_mouse_init);

module_hid_driver() instead.

--
With Best Regards,
Andy Shevchenko
