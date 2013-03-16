Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab3CPO5a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 10:57:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53793 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab3CPO53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 10:57:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH 3/3] misc: ep93xx_pwm.c: fix section mismatch and use module_platform_driver
Date: Sat, 16 Mar 2013 14:57:24 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Ryan Mallon <rmallon@gmail.com>, gregkh@linuxfoundation.org
References: <201303151807.14074.hartleys@visionengravers.com>
In-Reply-To: <201303151807.14074.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303161457.24825.arnd@arndb.de>
X-Provags-ID: V02:K0:bi0HXtdTt1jncyXzpznolO1cPdSOTmYuAVewXV+RUu2
 9Al7w65WG0wAqqsxnL4gZf4cPxnCh/OzuVEpStTBbhEtzHmHpa
 xMuHJcPoR6inq2Lcb18jKv+cUo+IvLngfo5gXL6VqsfJyGdPzV
 LxOADlCPtTV9P4JDQFwVQOhKTdoBd7hLnjrLjPvqWPewOKDhpI
 UhzZZy0MsD9LTGlLGke7hU5xSy5vFKrjoZj9sGIFiqNo4ZOpdz
 NndTAl1+f0dVRJ/0FlSNNGh1uxAOGp0mnsWuLXmrB/R0sZT54/
 a45EQlT9eTLcE6VfGs5+88BtMqtwxMZDO2KrLv0sg+/1qUtXQ/
 0UTkyHuLuWvZXziWm+i8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 March 2013, H Hartley Sweeten wrote:
> Remove the __init tags from the ep93xx_pwm_probe() and
> ep93xx_pwm_remove() functions to fix the section mismatch
> warnings.
> 
> Use module_platform_driver() to remove the init/exit boilerplate.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
