Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751199AbaKZT0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 14:26:17 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40253 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaKZT0P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 14:26:15 -0500
Content-Type: text/plain; charset=koi8-r
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH v2] omap: i2c: don't check bus state IP rev3.3 and earlier
From: Alexander Kochetkov <al.kochet@gmail.com>
In-Reply-To: <7hvbm3jdq1.fsf@deeprootsystems.com>
Date: Wed, 26 Nov 2014 22:26:10 +0300
Cc: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <65BAE81D-E894-48EB-B5A0-0D0FFB9B448F@gmail.com>
References: <20141124210809.GG2817@atomide.com> <1416867655-22232-1-git-send-email-al.kochet@gmail.com> <20141125141924.GD1843@katana> <7E0A0B24-91D5-41A4-B007-004C5965D0D7@gmail.com> <7hvbm3jdq1.fsf@deeprootsystems.com>
To: Kevin Hilman <khilman@kernel.org>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


25 нояб. 2014 г., в 22:13, Kevin Hilman <khilman@kernel.org> написал(а):

> I'll test your patch on all my OMAP boards.  Put whatever debug output
> you want, and I'll send you links to all the boot output.

Hello, Kevin!

I've sent the patch[1]. Could you be so kind to run it on all your OMAP boards?
Thank you very much!
It is not urgent at all.

What is the preferred way for giving patches for you (for future)?
I have one more fixes for i2c-omap (I think final).
I don't want to break tests anymore.

And I found, that n900 boot test PASS, but in fact it doesn't[2].

Alexander.

[1] http://marc.info/?l=linux-i2c&m=141702877518332&w=2
[2] http://status.armcloud.us/boot/omap3-n900/job/next/kernel/next-20141124/defconfig/arm-omap2plus_defconfig/

