Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbaKUA3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 19:29:47 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:63328 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbaKUA3p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 19:29:45 -0500
Content-Type: text/plain; charset=koi8-r
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] i2c: omap: fix i207 errata handling
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <1416529011-21803-1-git-send-email-al.kochet@gmail.com>
Date: Fri, 21 Nov 2014 03:29:40 +0300
Cc: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, Aaro Koskinen <aaro.koskinen@iki.fi>
Content-Transfer-Encoding: 8BIT
Message-Id: <089B5BDA-682D-46B6-869F-A6ADDFE691C3@gmail.com>
References: <1416529011-21803-1-git-send-email-al.kochet@gmail.com>
To: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Kochetkov <al.kochet@gmail.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

21 нояб. 2014 г., в 3:16, Alexander Kochetkov <al.kochet@gmail.com> написал(а):

> commit 6d9939f651419a63e091105663821f9c7d3fec37 (i2c: omap: split out [XR]DR
> and [XR]RDY) changed the way how errata i207 (I2C: RDR Flag May Be Incorrectly
> Set) get handled.

It's is seen if open 6d9939f651419a63e09^ and 6d9939f651419a63e09 side by side:

6d9939f651419a63e09^:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/i2c/busses/i2c-omap.c?id=540a4790f7da0d3ca5ad9d726f198a5eb4db05ec#n800

6d9939f651419a63e09:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/i2c/busses/i2c-omap.c?id=6d9939f651419a63e091105663821f9c7d3fec37#n800

Errata "2C: RDR Flag May Be Incorrectly Set"
http://www.ti.com/lit/er/sprz319f/sprz319f.pdf

21 нояб. 2014 г., в 3:16, Alexander Kochetkov <al.kochet@gmail.com> написал(а):

> Found by code review. Real impact haven't seen.
> Tested on Beagleboard XM C.

Does anybody know the "certain rare conditions" when RDR errata appears?
I tested without luck (Beagleboard XM C).

