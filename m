Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab3AKWIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:08:32 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:33063 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3AKWIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:08:31 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Laurent Navet <laurent_navet@yahoo.com>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 0/6] staging: line6: more checkpatch.pl warnings fixes
Date: Fri, 11 Jan 2013 23:08:08 +0100
Message-Id: <1357942094-11495-1-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series addresses the remaining checkpatch.pl warnings that are easy to
fix.  This takes the line6 driver another step closer to getting merged as an
ALSA driver.

Stefan Hajnoczi (6):
  staging: line6: rename MidiBuffer to avoid CamelCase
  staging: line6: wrap comment to 80 chars in driver.c
  staging: line6: use pr_err() instead of printk(KERN_ERR, ...)
  staging: line6: wrap lines to 80 chars in pod.c
  staging: line6: drop ToneportSourceInfo CamelCase name
  staging: line6: avoid CamelCase POD_* enums in pod.c

 drivers/staging/line6/driver.c   |  4 ++--
 drivers/staging/line6/driver.h   |  2 +-
 drivers/staging/line6/midi.c     |  2 +-
 drivers/staging/line6/midi.h     |  4 ++--
 drivers/staging/line6/midibuf.c  | 25 +++++++++++++------------
 drivers/staging/line6/midibuf.h  | 22 +++++++++++-----------
 drivers/staging/line6/pod.c      | 17 ++++++++++-------
 drivers/staging/line6/toneport.c |  6 ++----
 8 files changed, 42 insertions(+), 40 deletions(-)

-- 
1.8.0.2

