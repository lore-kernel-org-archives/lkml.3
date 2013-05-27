Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab3E0PUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 11:20:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64570 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3E0PUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 11:20:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH 00/14] misc/ep93xx_pwm: cleanup driver for conversion to PWM framework
Date: Mon, 27 May 2013 17:20:07 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, gregkh@linuxfoundation.org,
        Ryan Mallon <rmallon@gmail.com>, mcrapet@gmail.com,
        hsweeten@visionengravers.com
References: <201305241619.52328.hartleys@visionengravers.com>
In-Reply-To: <201305241619.52328.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305271720.08146.arnd@arndb.de>
X-Provags-ID: V02:K0:ywZvsUtIvgTFd84FHZ4bIE6g7wyJWkZFq07SOAlx0eS
 MSGvSxtyGLtxxuT0dbVoT36YHR7ZWY3qSBuQVZiCon3g9iurbp
 MmTqgdKFy5uBpfDtMP5GVUYOMwV1J4/RKl7nz31CaErBJBqa4i
 jRAqQFGeSXLpm4EyGytEgfZnLZM/X1cZHp+Qa6HxBSq/tPTO5A
 KFU9qHBx3oQBUi3fXoFBGbJ83R3HAd+GLY65/ERpTlZFyeba/p
 VZ8gu82ulW1eFjNNxWoUOm1r6C6i8ecey71L6jxiUi310NqnTc
 xTmZjS7r3yF9tCXjVmLc3idGsFMXUGNDaClpOSYlFYNkWDpQKp
 uMnMPqTeSGqdVw2bO4rw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 25 May 2013, H Hartley Sweeten wrote:
> This driver needs to be converted to the new PWM framework.
> 
> Before converting it clean up all the cruft,
> 
> H Hartley Sweeten (14):
>   misc/ep93xx_pwm: use managed device resources
>   misc/ep93xx_pwm: use {read,write}* instead of __raw_* versions for io
>   misc/ep93xx_pwm: remove ep93xx_pwm_{write,read}l() inline functions
>   misc/ep93xx_pwm: remove ep93xx_pwm_write_tc() inline function
>   misc/ep93xx_pwm: remove ep93xx_pwm_write_dc() inline function
>   misc/ep93xx_pwm: remove ep93xx_pwm_enable() inline function
>   misc/ep93xx_pwm: remove ep93xx_pwm_disable() inline function
>   misc/ep93xx_pwm: remove ep93xx_pwm_invert() inline function
>   misc/ep93xx_pwm: remove ep93xx_pwm_normal() inline function
>   misc/ep93xx_pwm: remove ep93xx_pwm_read_tc() inline function
>   misc/ep93xx_pwm: remove ep93xx_pwm_is_enabled() inline function
>   misc/ep93xx_pwm: remove ep93xx_pwm_is_inverted() inline function
>   misc/ep93xx_pwm: use module_platform_driver()
>   misc/ep93xx_pwm: use kstrtol instead of strict_strtol

Whole series:

Acked-by: Arnd Bergmann <arnd@arndb.de>

with or without my suggested change, your choice.
