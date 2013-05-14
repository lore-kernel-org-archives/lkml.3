Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab3ENMC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:02:57 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:37558 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756890Ab3ENMC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:02:56 -0400
MIME-Version: 1.0
In-Reply-To: <1367824503.6190.1.camel@phoenix>
References: <1367824503.6190.1.camel@phoenix>
Date: Tue, 14 May 2013 14:02:55 +0200
Message-ID: <CACRpkdYrN78Oae_4DKh6cdOWxiuNEZCQzicKKoN5dv1ws185LA@mail.gmail.com>
Subject: Re: [PATCH] ARM: U300: Add proper ifdef guard to fix build error when CONFIG_I2C_STU300=m
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 9:15 AM, Axel Lin <axel.lin@ingics.com> wrote:

> I got below build error if CONFIG_I2C_STU300=m.
>
> ERROR: "i2c_register_board_info" [arch/arm/mach-u300/i2c.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
>
> Fix it by adding proper ifdef guard in i2c.h and Makefile.
> So arch/arm/mach-u300/i2c.c will be compiled when CONFIG_I2C_STU300 is
> configured as built-in or as a module.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

This file will be deleted in v3.11, see:
http://marc.info/?l=linux-arm-kernel&m=136662534118633&w=2

Yours,
Linus Walleij
