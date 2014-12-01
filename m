Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353AbaLAUFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:05:03 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:51624 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101AbaLAUFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:05:00 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Alexander Kochetkov <al.kochet@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/2] i2c: omap: new fixes for driver
References: <1417294803-14729-1-git-send-email-al.kochet@gmail.com>
Date: Mon, 01 Dec 2014 12:04:57 -0800
In-Reply-To: <1417294803-14729-1-git-send-email-al.kochet@gmail.com>
	(Alexander Kochetkov's message of "Sun, 30 Nov 2014 01:00:01 +0400")
Message-ID: <7hoarn3zme.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Kochetkov <al.kochet@gmail.com> writes:

> The first patch fix i2c-omap driver for omap2420, found by code review and
> later reported by Tony Lindgren <tony@atomide.com> here[1].
> Candidate for stable?
>
> The second patch unhide the reson of system lockup.
>
> The patch is rebased on branch 'i2c/for-next' of
> git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
> (6e79807443cba7397cd855ed29d6faba51d4c893)
>
> Tony, could you check, what the patches fix the problem reported[1]?
> Kevin, could you run tests for patches on all omap boards?

Done.  Built v3.18-rc7 + these 2 patches using omap2plus_defconfig. Boot
logs here for your amusement:

http://people.linaro.org/~khilman/tmp/v3.18-rc7-2-gdf84e23f2864/arm-omap2plus_defconfig/

Kevin
