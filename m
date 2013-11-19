Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab3KSTiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:38:18 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:56125 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab3KSTiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:38:15 -0500
Date: Tue, 19 Nov 2013 19:38:09 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Florian Lobmaier <florian.lobmaier@ams.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: linux-next: Tree for Nov 19 (mfd/as3722)
Message-ID: <20131119193809.GD19953@lee--X1>
References: <20131119143954.74186994a2e977f244ac95e0@canb.auug.org.au>
 <528B9F03.6040601@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <528B9F03.6040601@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Nov 2013, Randy Dunlap wrote:

> On 11/18/13 19:39, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Please do *not* add any v3.14 material to linux-next until after
> > v3.13-rc1 is released.
> > 
> > Changes since 20131118:
> > 
> 
> on i386:
> 
> when CONFIG_I2C=m
> (a.k.a. the dangers of having a bool depend on a tristate)
> 
> drivers/built-in.o: In function `as3722_i2c_probe':
> as3722.c:(.text+0x41456): undefined reference to `devm_regmap_init_i2c'
> drivers/built-in.o: In function `as3722_i2c_driver_init':
> as3722.c:(.init.text+0x1b5d): undefined reference to `i2c_register_driver'
> drivers/built-in.o: In function `as3722_i2c_driver_exit':
> as3722.c:(.exit.text+0x41e): undefined reference to `i2c_del_driver'

I accepted a patch which fixes this yesterday and intended to send post -rc1.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
