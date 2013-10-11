Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab3JKIuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 04:50:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51154 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587Ab3JKIuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:50:01 -0400
From: Matias Bjorling <m@bjorling.me>
To: willy@linux.intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        Matias Bjorling <m@bjorling.me>
Subject: [PATCH 0/2] NVMe: Refactoring v2
Date: Fri, 11 Oct 2013 10:48:51 +0200
Message-Id: <1381481333-23888-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two refactor patches that increases code clarity.

The to-be blk-mq proposal patchset utilizes these as part of its transformation.
They are also useful for the current codebase and therefore submitted upfront.

v2:

For some reason I submitted the wrong patch file, with a missing underline in
sq_tail.

Matias Bjorling (2):
  NVMe: Refactor doorbell
  NVMe: Extract admin queue size

 drivers/block/nvme-core.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

-- 
1.8.1.2

