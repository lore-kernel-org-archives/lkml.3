Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab3FFTgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 15:36:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64299 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab3FFTfv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 15:35:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 4/4] ARM: ux500: Remove call to u8500_of_init_devices() - again
Date: Thu, 6 Jun 2013 21:35:20 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com
References: <1370517676-10909-1-git-send-email-lee.jones@linaro.org> <201306061758.25106.arnd@arndb.de> <20130606165053.GU3370@gmail.com>
In-Reply-To: <20130606165053.GU3370@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201306062135.21047.arnd@arndb.de>
X-Provags-ID: V02:K0:vJpTPrE4OTwhe9YcWZYww5QxO+UVLslxBm9R/F/npE6
 AH6Nu1ie3KiFR+vw0y5bauJDzj/GqxGv5EtmVps5vFQIzegga8
 Ge3bwoLUbIEB5Kr8SWwitC3C4giwx5qTkDQSbJZLJ326QMalkE
 DtlF5ZOGPCFgXZjL2vXvtZm2TwGUbddM2YQ+DVOhAlIP4HIlZD
 L6P1lWQAZA+nFr8bBONqKQvBppum1jbXaf7k6wNGXfClzb5DKk
 a81q8HTKSxaGjaypSLZP1FPEtxJOIC+Ut1GMQN/wm8JeHacQ3Y
 wpTcwQIipBCJbqMlkzE1B33j6IOQxKAYJLfPh10G6wecMb9eJd
 spIzvv4AV9Vp/gmjLDNo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 June 2013, Lee Jones wrote:
> https://git.kernel.org/cgit/linux/kernel/git/linusw/linux-stericsson.git/commit/arch/arm/mach-ux500/cpu-db8500.c?h=next&amp;id=1e74043a29cdec67279d6e4f494dd1674a1b2365
> 
> For some reason (I suspect a merge error), u8500_of_init_devices
> reappeared.
> 

>From what I can see, that match you cited has never made it into the mainline kernel.

	Arnd
