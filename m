Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222Ab3B0QZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:25:16 -0500
Received: from mx2.promwad.com ([91.149.128.90]:49896 "EHLO mx2.promwad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265Ab3B0QZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:25:14 -0500
From: Michail Kurachkin <michail.kurachkin@promwad.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kuten Ivan <Ivan.Kuten@promwad.com>,
        "benavi@marvell.com" <benavi@marvell.com>,
        Palstsiuk Viktar <Viktar.Palstsiuk@promwad.com>,
        Dmitriy Gorokh <dmitriy.gorokh@promwad.com>
CC: Michail Kurochkin <michail.kurachkin@promwad.com>
Subject: [PATCH 4/9] added TODO file for si3226x
Date: Wed, 27 Feb 2013 19:25:05 +0300
Message-ID: <1361982305-5284-1-git-send-email-michail.kurachkin@promwad.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michail Kurochkin <michail.kurachkin@promwad.com>

Signed-off-by: Michail Kurochkin <michail.kurachkin@promwad.com>
---
 drivers/staging/si3226x/TODO |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/si3226x/TODO

diff --git a/drivers/staging/si3226x/TODO b/drivers/staging/si3226x/TODO
new file mode 100644
index 0000000..83c5958
--- /dev/null
+++ b/drivers/staging/si3226x/TODO
@@ -0,0 +1,2 @@
+1) mutex_lock(&slic_chr_dev_lock);
+This locking is very heavy handed. You are holding it across the entire open, close, read, write, ioctl, and it is protecting a bunch of different things.
-- 
1.7.5.4

