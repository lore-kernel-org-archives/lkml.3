Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaKZVdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 16:33:46 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:45446 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaKZVdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 16:33:44 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Alexander Kochetkov <al.kochet@gmail.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH v2] omap: i2c: don't check bus state IP rev3.3 and earlier
References: <20141124210809.GG2817@atomide.com>
	<1416867655-22232-1-git-send-email-al.kochet@gmail.com>
	<20141125141924.GD1843@katana>
	<7E0A0B24-91D5-41A4-B007-004C5965D0D7@gmail.com>
	<7hvbm3jdq1.fsf@deeprootsystems.com>
	<65BAE81D-E894-48EB-B5A0-0D0FFB9B448F@gmail.com>
Date: Wed, 26 Nov 2014 13:33:41 -0800
In-Reply-To: <65BAE81D-E894-48EB-B5A0-0D0FFB9B448F@gmail.com> (Alexander
	Kochetkov's message of "Wed, 26 Nov 2014 22:26:10 +0300")
Message-ID: <7hvbm1d4ui.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Kochetkov <al.kochet@gmail.com> writes:

> 25 нояб. 2014 г., в 22:13, Kevin Hilman <khilman@kernel.org> написал(а):
>
>> I'll test your patch on all my OMAP boards.  Put whatever debug output
>> you want, and I'll send you links to all the boot output.
>
> Hello, Kevin!
>
> I've sent the patch[1]. Could you be so kind to run it on all your OMAP boards?
> Thank you very much!
> It is not urgent at all.

Done.  Built for omap2plus_defconfig, boot reports for all my OMAP
boards here: 
http://people.linaro.org/~khilman/tmp/next-20141126-1-g760388ee02e4/arm-omap2plus_defconfig/

> What is the preferred way for giving patches for you (for future)?

Email is fine.  I have things fully automated for primary upstream trees
(mainline, linux-next, stable, etc.) but for stuff like this, I can
trigger one-off tests.

However, if Tony wants to have a branch (besides the one already goes to
linux-next) which I would add to the automation cycle, I'm willing to do that.

> I have one more fixes for i2c-omap (I think final).
> I don't want to break tests anymore.
>
> And I found, that n900 boot test PASS, but in fact it doesn't[2].
> [2] http://status.armcloud.us/boot/omap3-n900/job/next/kernel/next-20141124/defconfig/arm-omap2plus_defconfig/

Right.  For these boot tests, PASS means it got to a userspace shell,
which it did.  The kernel got some warnings etc. during boot, but it
still booted up to a shell.

Kevin
