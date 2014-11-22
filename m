Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbaKVOGR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 09:06:17 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:64822 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbaKVOGP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 09:06:15 -0500
Content-Type: text/plain; charset=koi8-r
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 2/4] i2c: omap: implement workaround for handling invalid BB-bit values
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <20141122132309.GC2679@katana>
Date: Sat, 22 Nov 2014 17:06:10 +0300
Cc: Alexander Kochetkov <al.kochet@gmail.com>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <B6D9B4D7-25CB-456F-88B4-EB6A53E33A9D@gmail.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com> <1416518925-20679-3-git-send-email-al.kochet@gmail.com> <20141121160808.GM7508@saruman> <20141122132309.GC2679@katana>
To: Wolfram Sang <wsa@the-dreams.de>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


22 нояб. 2014 г., в 16:23, Wolfram Sang <wsa@the-dreams.de> написал(а):

> Huh, I can't apply this one? Which kernel version is this based on?

v.3.13-rc8
It depends on PATCH 1/4

alexander@ubuntu:git.kernel.org.pub.scm.linux.kernel.git.stable.linux-stable$ git log --pretty=oneline --abbrev-commit -6
204c058 i2c: omap: add notes related to i2c multimaster mode
2b15417 i2c: omap: don't reset controller if Arbitration Lost detected
38ef30e i2c: omap: implement workaround for handling invalid BB-bit values
9b15135 i2c: omap: cleanup register definitions
a7483d8 Fixes: 1d7afc9 i2c: omap: ack IRQ in parts
7e22e91 Linux 3.13-rc8

