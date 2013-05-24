Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438Ab3EXXVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 19:21:13 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.202]:55741 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724Ab3EXXVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 19:21:11 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-6.tower-131.messagelabs.com!1369437668!16570225!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.8.6.1; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/14] misc/ep93xx_pwm: cleanup driver for conversion to PWM framework
Date: Fri, 24 May 2013 16:19:51 -0700
User-Agent: KMail/1.9.9
CC: <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>, <mcrapet@gmail.com>,
        <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201305241619.52328.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver needs to be converted to the new PWM framework.

Before converting it clean up all the cruft,

H Hartley Sweeten (14):
  misc/ep93xx_pwm: use managed device resources
  misc/ep93xx_pwm: use {read,write}* instead of __raw_* versions for io
  misc/ep93xx_pwm: remove ep93xx_pwm_{write,read}l() inline functions
  misc/ep93xx_pwm: remove ep93xx_pwm_write_tc() inline function
  misc/ep93xx_pwm: remove ep93xx_pwm_write_dc() inline function
  misc/ep93xx_pwm: remove ep93xx_pwm_enable() inline function
  misc/ep93xx_pwm: remove ep93xx_pwm_disable() inline function
  misc/ep93xx_pwm: remove ep93xx_pwm_invert() inline function
  misc/ep93xx_pwm: remove ep93xx_pwm_normal() inline function
  misc/ep93xx_pwm: remove ep93xx_pwm_read_tc() inline function
  misc/ep93xx_pwm: remove ep93xx_pwm_is_enabled() inline function
  misc/ep93xx_pwm: remove ep93xx_pwm_is_inverted() inline function
  misc/ep93xx_pwm: use module_platform_driver()
  misc/ep93xx_pwm: use kstrtol instead of strict_strtol

 drivers/misc/ep93xx_pwm.c | 187 +++++++++++++---------------------------------
 1 file changed, 50 insertions(+), 137 deletions(-)

-- 
1.8.1.4

