Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbaIWXMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 19:12:13 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:62469 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaIWXML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 19:12:11 -0400
Date: Tue, 23 Sep 2014 19:12:09 -0400
From: Elshad Mustafayev <elshadimo@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] driver: staging: android: binder.c: Fixed line over 80
 characters warning.
Message-ID: <20140923231209.GA3785@emustafa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue.

Signed-off-by: Elshad Mustafayev <elshadimo@gmail.com>
---
 drivers/staging/android/binder.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index c69c40d..71424bf 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -664,8 +664,9 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 		ALIGN(offsets_size, sizeof(void *));
 
 	if (size < data_size || size < offsets_size) {
-		binder_user_error("%d: got transaction with invalid size %zd-%zd\n",
-				proc->pid, data_size, offsets_size);
+		binder_user_error(
+			"%d: got transaction with invalid size %zd-%zd\n",
+			proc->pid, data_size, offsets_size);
 		return NULL;
 	}
 
-- 
1.9.1

