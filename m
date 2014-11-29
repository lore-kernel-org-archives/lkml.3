Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbaK2VAM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 16:00:12 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:48098 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbaK2VAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 16:00:10 -0500
From: Alexander Kochetkov <al.kochet@gmail.com>
To: Kevin Hilman <khilman@kernel.org>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, Wolfram Sang <wsa@the-dreams.de>,
        Alexander Kochetkov <al.kochet@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 0/2] i2c: omap: new fixes for driver
Date: Sun, 30 Nov 2014 01:00:01 +0400
Message-Id: <1417294803-14729-1-git-send-email-al.kochet@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch fix i2c-omap driver for omap2420, found by code review and
later reported by Tony Lindgren <tony@atomide.com> here[1].
Candidate for stable?

The second patch unhide the reson of system lockup.

The patch is rebased on branch 'i2c/for-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux
(6e79807443cba7397cd855ed29d6faba51d4c893)

Tony, could you check, what the patches fix the problem reported[1]?
Kevin, could you run tests for patches on all omap boards?

Regards,
Alexander.

[1] http://www.spinics.net/lists/linux-i2c/msg17811.html

Alexander Kochetkov (2):
  i2c: omap: fix buffer overruns during RX/TX data processing
  i2c: omap: show that the reason of system lockup is an unhandled ISR
    event

 drivers/i2c/busses/i2c-omap.c |   64 ++++++++++++++++++++++++++++++++---------
 1 file changed, 50 insertions(+), 14 deletions(-)

-- 
1.7.9.5

