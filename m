Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621AbaJGPXe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 11:23:34 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:37955 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbaJGPXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 11:23:31 -0400
Message-ID: <54340568.7090700@gmail.com>
Date: Tue, 07 Oct 2014 17:23:20 +0200
From: Dzmitry Sledneu <dzmitry.sledneu@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH v2 1/2] staging: gs_fpgaboot: Fix "Possible unnecessary KERN_INFO"
 checkpatch.pl warning
References: <5433FA93.8000607@gmail.com> <5433FB18.9000009@gmail.com>
In-Reply-To: <5433FB18.9000009@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix "Possible unnecessary KERN_INFO" checkpatch.pl warning

Signed-off-by: Dzmitry Sledneu <dzmitry.sledneu@gmail.com>

---
 drivers/staging/gs_fpgaboot/gs_fpgaboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
index 6aa9d7c..6129164 100644
--- a/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
+++ b/drivers/staging/gs_fpgaboot/gs_fpgaboot.c
@@ -58,7 +58,7 @@ static void datadump(char *msg, void *m, int n)
 
 	for (i = 0; i < n; i++) {
 		if ((i&0xf) == 0)
-			pr_info(KERN_INFO "\n  0x%4x: ", i);
+			pr_info("\n  0x%4x: ", i);
 
 		pr_info("%02X ", c[i]);
 	}
-- 
2.1.2
