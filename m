Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaKZVZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:25:57 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40653 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaKZVZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:25:55 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Alexander Kochetkov <al.kochet@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC] i2c: omap: TEST: do IP reset during probe.
References: <1416685634-5864-3-git-send-email-al.kochet@gmail.com>
	<1417028722-29306-1-git-send-email-al.kochet@gmail.com>
Date: Wed, 26 Nov 2014 13:25:52 -0800
In-Reply-To: <1417028722-29306-1-git-send-email-al.kochet@gmail.com>
	(Alexander Kochetkov's message of "Wed, 26 Nov 2014 23:05:22 +0400")
Message-ID: <7hzjbdd57j.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Kochetkov <al.kochet@gmail.com> writes:

> NOT FOR UPSTREAM
>
> The patch checks if IP reset during probe could bring I2C bus
> to a free state on omap2430 - omap3530 boards.
>
> I guess, IP hold one of I2C lines in a low state.
> I guess, u-boot haven't sent a stop condition.
>
> The patch is rebased on branch 'i2c/for-next' of
> git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
> (6e79807443cba7397cd855ed29d6faba51d4c893)
>
> Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
> Reported-by: Kevin Hilman <khilman@kernel.org>
> Tested-by: Kevin Hilman <khilman@kernel.org>

Built for omap2plus_defconfig and tested on all my OMAP boards.  Results
here:

http://people.linaro.org/~khilman/tmp/next-20141126-1-g760388ee02e4/arm-omap2plus_defconfig/
