Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbaICW6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:58:43 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:33215 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618AbaICW6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:58:41 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mod_devicetable: add space before */
Date: Thu,  4 Sep 2014 00:58:23 +0200
Message-Id: <1409785103-14262-2-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409785103-14262-1-git-send-email-fransklaver@gmail.com>
References: <1409785103-14262-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Match the style of the other one-line comments.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 include/linux/mod_devicetable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index 745def8..c471047 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -252,7 +252,7 @@ struct pcmcia_device_id {
 
 	__u32 		prod_id_hash[4];
 
-	/* not matched against in kernelspace*/
+	/* not matched against in kernelspace */
 	const char *	prod_id[4];
 
 	/* not matched against */
-- 
2.1.0

