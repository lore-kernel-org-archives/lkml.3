Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab3FNQwk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 12:52:40 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50078 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3FNQwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 12:52:39 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        John Stultz <john.stultz@linaro.org>, rtc-linux@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: [PATCH 0/9 v3] RFC: timekeeping: rtc: change hctosys mechanism
Date: Fri, 14 Jun 2013 18:52:03 +0200
Message-Id: <1371228732-5749-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <51BA1FF7.4000206@ahsoftware.de>
References: <51BA1FF7.4000206@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Because I've become a request which made me slightly more optimistic about
the RFC patches, I've spend some more time on the patches doing cosmetic.
I know think the "quickly done" is gone and they might be ready for
submission.

The whole series consists more or less of 3 mini-series.

The first two patches are already in -mm, the 3. should end there too.

Then there are 3 patches to change the hctosys mechanism and another
3 patches to implement read_timeval for rtc_ops, together with an example
implementation for read_timeval in rtc-hid-sensor-time.

The introductory message of my first post of this series still describes
all changes to hctosys, what the additional 3 patches with read_timeval
are doing should be obvious.

Regards,

Alexander Holler

BTW: rtc_device_unregister is broken in 3.10-rc5, most likely because
of the switch to devm*. But I will start another thread for that as this
is unrelated to this series of patches.
