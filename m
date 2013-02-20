Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934590Ab3BTHxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 02:53:11 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:35364 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934531Ab3BTHxK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 02:53:10 -0500
MIME-Version: 1.0
Date: Wed, 20 Feb 2013 13:23:09 +0530
Message-ID: <CAKohpomdJBWrwiNx8T2-vT-b5wponNCMw_PGDMAULgoWidbOZQ@mail.gmail.com>
Subject: [Query]: Regmap v3.8: Compilation Warning: regmap_read_debugfs()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

I am getting compilation warning while compiling v3.8

commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Feb 18 15:58:34 2013 -0800

    Linux 3.8



Warning:

CC      drivers/base/regmap/regmap-debugfs.o
drivers/base/regmap/regmap-debugfs.c: In function ‘regmap_read_debugfs’:
drivers/base/regmap/regmap-debugfs.c:180:9: warning: ‘ret’ may be used
uninitialized in this function [-Wmaybe-uninitialized]


I am unable to understand why this warning is coming and that too on
line 180 (as that doesn't use this variable). I can't see how this variable is
used uninitialized.

Toolchain i used:

arm-linux-gnueabihf-gcc (crosstool-NG
linaro-1.13.1-4.7-2012.12-20121214 - Linaro GCC 2012.12) 4.7.3
20121205 (prerelease)

--
viresh
