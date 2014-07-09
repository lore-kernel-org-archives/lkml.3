Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbaGINET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:04:19 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:34374 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949AbaGINER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:04:17 -0400
From: Alex Elder <elder@linaro.org>
To: akpm@linux-foundation.org
Cc: ak@linux.intel.com, bp@suse.de, jack@suse.cz, john.stultz@linaro.org,
        pmladek@suse.cz, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] printk: some minor fixups
Date: Wed,  9 Jul 2014 08:04:12 -0500
Message-Id: <1404911056-29064-1-git-send-email-elder@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series makes some minor changes to kernel/printk/printk.c.
I've been poking around that file and will have a few more
substantive changes to propose soon, but I've been carrying
around these little things for a bit and thought I should
just get them out there.

					-Alex

This series, based on v3.16-rc4, is available here:
    http://git.linaro.org/landing-teams/working/broadcom/kernel.git
    Branch review/minor-printk-fixes

Alex Elder (4):
  printk: rename DEFAULT_MESSAGE_LOGLEVEL
  printk: fix some comments
  printk: use a clever macro
  printk: miscellaneous cleanups

 include/linux/printk.h |  2 +-
 kernel/printk/printk.c | 63 ++++++++++++++++++++++----------------------------
 2 files changed, 29 insertions(+), 36 deletions(-)

-- 
1.9.1

