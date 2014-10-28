Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaJ1OS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 10:18:26 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34447 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaJ1OSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 10:18:25 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-aa-544fa5adf1e1
Subject: [PATCH] Makefile: sort list of defconfig targets in make help output
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Date: Tue, 28 Oct 2014 17:18:20 +0400
Message-id: <20141028141820.14137.64256.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPJMWRmVeSWpSXmKPExsVy+t/xq7prl/qHGBzutrH4sbOX1eLPrh1M
	Fpd3zWGzaNl3gcmBxaNvyypGjzMLjrB7fN4kF8AcxWWTkpqTWZZapG+XwJVx6f0SpoIHrBWn
	1qxlamD8ztLFyMkhIWAiMa/9BCOELSZx4d56ti5GLg4hgaWMEu83HmCEcBqZJI5cfMIEUiUs
	4Ctx/8IvVhCbTcBMYtu+22DdIgLxEh0N65hBbBYBVYn2x4vANvAKGEvMPbuGHcQWFZCTWHm5
	hRUiLijxY/I9oBoODmYBdYkpU3JBwswC8hKb17xlnsDIOwtJ1SyEqllIqhYwMq9iFE0tTS4o
	TkrPNdIrTswtLs1L10vOz93ECAm0rzsYlx6zOsQowMGoxMMbweIfIsSaWFZcmXuIUYKDWUmE
	NyIGKMSbklhZlVqUH19UmpNafIiRiYNTqoHR8nPab9X7MaaGRjFq3xm0N5Te2J6ULnZG4E3h
	ren2VxU/8jYx6YZLe3NnTMpeL7Y7oFCJfXGCZKbT2e3zivw4DJ9cK1rUtvBs9nzZxcxZ///6
	/YlZe+u2xu3JyVF1vgdS19gJ6UpK26ozcMWs+8X6Jf5nJO/uw5ydBtd4z4TaNPz3PV+xZaUS
	S3FGoqEWc1FxIgDYpwluEgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without sorting this list is completely unreadable for ARCH=arm.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 52c1297..63f05dc 100644
--- a/Makefile
+++ b/Makefile
@@ -1234,7 +1234,7 @@ rpm: include/config/kernel.release FORCE
 # ---------------------------------------------------------------------------
 
 boards := $(wildcard $(srctree)/arch/$(SRCARCH)/configs/*_defconfig)
-boards := $(notdir $(boards))
+boards := $(sort $(notdir $(boards)))
 board-dirs := $(dir $(wildcard $(srctree)/arch/$(SRCARCH)/configs/*/*_defconfig))
 board-dirs := $(sort $(notdir $(board-dirs:/=)))
 

