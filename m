Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3AOO1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 09:27:52 -0500
Received: from arrakis.dune.hu ([78.24.191.176]:56815 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757013Ab3AOO1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 09:27:51 -0500
Date: Tue, 15 Jan 2013 15:27:46 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] drivers/base/cpu.c: Fix typo in comment
Message-ID: <20130115142746.GA29451@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 drivers/base/cpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 6345294..fb10728 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -224,7 +224,7 @@ static void cpu_device_release(struct device *dev)
 	 * by the cpu device.
 	 *
 	 * Never copy this way of doing things, or you too will be made fun of
-	 * on the linux-kerenl list, you have been warned.
+	 * on the linux-kernel list, you have been warned.
 	 */
 }
 
