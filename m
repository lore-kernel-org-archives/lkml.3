Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbaBKIYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:24:45 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:55521 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaBKIYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:24:41 -0500
From: Juri Lelli <juri.lelli@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@gmail.com>
Subject: [PATCH 0/2] A couple of sched patches
Date: Tue, 11 Feb 2014 09:24:25 +0100
Message-Id: <1392107067-19907-1-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This two patches (on top of tip/master as of today) fix bugs
in sched/core. First one is a repost of
http://comments.gmane.org/gmane.linux.kernel/1638425, and exposed,
at least to me, another bug (fixed by second patch).

Regards,

- Juri

Juri Lelli (2):
  sched/core: fix sched_rt_global_validate
  sched/core: make dl_b->lock IRQ safe

 kernel/sched/core.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

-- 
1.7.9.5

