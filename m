Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab3JRO7Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:59:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:54435 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab3JRO7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:59:24 -0400
Date: Fri, 18 Oct 2013 16:59:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-arm-kernel@lists.infradead.org
cc: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        Sascha Hauer <kernel@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: [BUILD BROKEN] Current Linus' master and -next don't build for
 imx_v6_v7_defconfig
Message-ID: <Pine.LNX.4.64.1310181632160.9158@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:fKdBI67OR69XYAfbZwC8RXZKh8zUWlYvHQfJbj1HiVK
 +CCKTH5COXnhSpGgyiH5X73dkw/RT1QlXZgzkE7HRgUqleVNmC
 /9aEbM7xxSQBe7/VEwfzzG1cC+QEF+beUOLldl84mo6FggIuWr
 tq0UXVZaxPhPX5k1w9Egm6+pRKymYXNK9UQXhqolO1qXtbQflY
 NCeFHew3ee1vY/KWkuSJdj0WO+lEInmgImVHvvQN1jajQU3MQ5
 Y+ONYKOxmDmk284Pe7W5tGO971DOBu+NsoinN8HF2/fA/jF/jG
 IC84qwtV1bFTantsbB1IVWH/IC9HsIr3iqVsCMvd8G18+h11pw
 rXy6WGVIp7/4GAayb5AMcwXuYSr/aM0E1DKvamfAYgjli51c+R
 DuVAEwIVl41HA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

On current Linus' tree as of 04919af as well as -next since 16.10, IIRC, 
compilation is broken for i.MX3*, including the default 
imx_v6_v7_defconfig. The toolchain used is

arm-none-linux-gnueabi-gcc (Sourcery CodeBench Lite 2012.09-64) 4.7.2

and here's the log (path stripped for readability)

arch/arm/lib/copy_template.S: Assembler messages:
arch/arm/lib/copy_template.S:100: Error: selected processor does not support ARM mode `ldralt r3,[r1],#4'
arch/arm/lib/copy_template.S:100: Error: selected processor does not support ARM mode `ldralt r4,[r1],#4'
arch/arm/lib/copy_template.S:100: Error: selected processor does not support ARM mode `ldralt r5,[r1],#4'
arch/arm/lib/copy_template.S:100: Error: selected processor does not support ARM mode `ldralt r6,[r1],#4'
arch/arm/lib/copy_template.S:100: Error: selected processor does not support ARM mode `ldralt r7,[r1],#4'
arch/arm/lib/copy_template.S:100: Error: selected processor does not support ARM mode `ldralt r8,[r1],#4'
arch/arm/lib/copy_template.S:100: Error: selected processor does not support ARM mode `ldralt ip,[r1],#4'
arch/arm/lib/copy_template.S:100: Error: selected processor does not support ARM mode `ldralt lr,[r1],#4'
arch/arm/lib/copy_template.S:118: Error: selected processor does not support ARM mode `ldralt r3,[r1],#4'
arch/arm/lib/copy_template.S:119: Error: selected processor does not support ARM mode `ldralt r4,[r1],#4'
arch/arm/lib/copy_template.S:120: Error: selected processor does not support ARM mode `ldralt r5,[r1],#4'
arch/arm/lib/copy_template.S:121: Error: selected processor does not support ARM mode `ldralt r6,[r1],#4'
arch/arm/lib/copy_template.S:122: Error: selected processor does not support ARM mode `ldralt r7,[r1],#4'
arch/arm/lib/copy_template.S:123: Error: selected processor does not support ARM mode `ldralt r8,[r1],#4'
arch/arm/lib/copy_template.S:124: Error: selected processor does not support ARM mode `ldralt lr,[r1],#4'
arch/arm/lib/copy_template.S:173: Error: selected processor does not support ARM mode `ldralt lr,[r1],#4'
arch/arm/lib/copy_template.S:243: Error: selected processor does not support ARM mode `ldralt r4,[r1],#4'
arch/arm/lib/copy_template.S:243: Error: selected processor does not support ARM mode `ldralt r5,[r1],#4'
arch/arm/lib/copy_template.S:243: Error: selected processor does not support ARM mode `ldralt r6,[r1],#4'
arch/arm/lib/copy_template.S:243: Error: selected processor does not support ARM mode `ldralt r7,[r1],#4'
arch/arm/lib/copy_template.S:243: Error: selected processor does not support ARM mode `ldralt r8,[r1],#4'
arch/arm/lib/copy_template.S:243: Error: selected processor does not support ARM mode `ldralt r9,[r1],#4'
arch/arm/lib/copy_template.S:243: Error: selected processor does not support ARM mode `ldralt ip,[r1],#4'
arch/arm/lib/copy_template.S:243: Error: selected processor does not support ARM mode `ldralt lr,[r1],#4'
arch/arm/lib/copy_template.S:243: Error: selected processor does not support ARM mode `ldralt lr,[r1],#4'
arch/arm/lib/copy_template.S:245: Error: selected processor does not support ARM mode `ldralt r4,[r1],#4'
arch/arm/lib/copy_template.S:245: Error: selected processor does not support ARM mode `ldralt r5,[r1],#4'
arch/arm/lib/copy_template.S:245: Error: selected processor does not support ARM mode `ldralt r6,[r1],#4'
arch/arm/lib/copy_template.S:245: Error: selected processor does not support ARM mode `ldralt r7,[r1],#4'
arch/arm/lib/copy_template.S:245: Error: selected processor does not support ARM mode `ldralt r8,[r1],#4'
arch/arm/lib/copy_template.S:245: Error: selected processor does not support ARM mode `ldralt r9,[r1],#4'
arch/arm/lib/copy_template.S:245: Error: selected processor does not support ARM mode `ldralt ip,[r1],#4'
arch/arm/lib/copy_template.S:245: Error: selected processor does not support ARM mode `ldralt lr,[r1],#4'
arch/arm/lib/copy_template.S:245: Error: selected processor does not support ARM mode `ldralt lr,[r1],#4'
arch/arm/lib/copy_template.S:247: Error: selected processor does not support ARM mode `ldralt r4,[r1],#4'
arch/arm/lib/copy_template.S:247: Error: selected processor does not support ARM mode `ldralt r5,[r1],#4'
arch/arm/lib/copy_template.S:247: Error: selected processor does not support ARM mode `ldralt r6,[r1],#4'
arch/arm/lib/copy_template.S:247: Error: selected processor does not support ARM mode `ldralt r7,[r1],#4'
arch/arm/lib/copy_template.S:247: Error: selected processor does not support ARM mode `ldralt r8,[r1],#4'
arch/arm/lib/copy_template.S:247: Error: selected processor does not support ARM mode `ldralt r9,[r1],#4'
arch/arm/lib/copy_template.S:247: Error: selected processor does not support ARM mode `ldralt ip,[r1],#4'
arch/arm/lib/copy_template.S:247: Error: selected processor does not support ARM mode `ldralt lr,[r1],#4'
arch/arm/lib/copy_template.S:247: Error: selected processor does not support ARM mode `ldralt lr,[r1],#4'
make[2]: *** [arch/arm/lib/copy_from_user.o] Error 1
make[1]: *** [arch/arm/lib] Error 2
make[1]: *** Waiting for unfinished jobs....

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
