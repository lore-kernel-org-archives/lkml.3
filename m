Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141Ab3JJSaA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:30:00 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63115 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab3JJS37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:29:59 -0400
From: Matias Bjorling <m@bjorling.me>
To: willy@linux.intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        Matias Bjorling <m@bjorling.me>
Subject: [PATCH 0/2] NVMe: Refactoring
Date: Thu, 10 Oct 2013 20:29:45 +0200
Message-Id: <1381429787-4146-1-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two refactor patches that increases the code clarity.

The to-be blk-mq proposal patchset utilizes these as part of its transformation.
They are also useful for the current codebase and therefore submitted upfront.

Matias Bjorling (2):
  NVMe: Refactor doorbell
  NVMe: Extract admin queue size

 drivers/block/nvme-core.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

-- 
1.8.1.2

