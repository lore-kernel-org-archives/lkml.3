Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab3EZXcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 19:32:11 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:42148 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab3EZXcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 19:32:10 -0400
Message-ID: <51A29B73.80604@gmail.com>
Date: Mon, 27 May 2013 09:32:03 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        gregkh@linuxfoundation.org, mcrapet@gmail.com,
        hsweeten@visionengravers.com
Subject: Re: [PATCH 00/14] misc/ep93xx_pwm: cleanup driver for conversion
 to PWM framework
References: <201305241619.52328.hartleys@visionengravers.com>
In-Reply-To: <201305241619.52328.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/05/13 09:19, H Hartley Sweeten wrote:
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
> 
>  drivers/misc/ep93xx_pwm.c | 187 +++++++++++++---------------------------------
>  1 file changed, 50 insertions(+), 137 deletions(-)
> 

Series looks fine to me.

Reviewed-by: Ryan Mallon <rmallon@gmail.com>

~Ryan

