Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaLXN4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 08:56:14 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:33962 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaLXN4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 08:56:12 -0500
From: Robert Nachlinger <robert.nachlinger@googlemail.com>
To: airlied@linux.ie
Cc: linux-kernel@vger.kernel.org,
        Robert Nachlinger <robert.nachlinger@googlemail.com>
Subject: [PATCH] Include: linux: fixed a couple of trailing whitespace errors include agpgart.h
Date: Wed, 24 Dec 2014 14:55:01 +0100
Message-Id: <1419429301-18057-1-git-send-email-robert.nachlinger@googlemail.com>
X-Mailer: git-send-email 2.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed a couple of trailing whitespace coding style errors in
agpgart.h.

Signed-off-by: Robert Nachlinger <robert.nachlinger@googlemail.com>
---
 include/linux/agpgart.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/agpgart.h b/include/linux/agpgart.h
index c6b61ca..973592b 100644
--- a/include/linux/agpgart.h
+++ b/include/linux/agpgart.h
@@ -17,9 +17,9 @@
  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
  * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
- * JEFF HARTMANN, OR ANY OTHER CONTRIBUTORS BE LIABLE FOR ANY CLAIM, 
- * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
- * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
+ * JEFF HARTMANN, OR ANY OTHER CONTRIBUTORS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
  * OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
  *
  */
@@ -72,9 +72,9 @@ struct agp_allocate {
 	int key;		/* tag of allocation            */
 	size_t pg_count;	/* number of pages              */
 	u32 type;		/* 0 == normal, other devspec   */
-	u32 physical;           /* device specific (some devices  
-				 * need a phys address of the     
-				 * actual page behind the gatt    
+	u32 physical;           /* device specific (some devices
+				 * need a phys address of the
+				 * actual page behind the gatt
 				 * table)                        */
 };
 
@@ -105,11 +105,11 @@ struct agp_controller {
 	struct agp_client *clients;
 };
 
-#define AGP_FF_ALLOW_CLIENT		0
-#define AGP_FF_ALLOW_CONTROLLER 	1
-#define AGP_FF_IS_CLIENT		2
-#define AGP_FF_IS_CONTROLLER		3
-#define AGP_FF_IS_VALID 		4
+#define AGP_FF_ALLOW_CLIENT	0
+#define AGP_FF_ALLOW_CONTROLLER	1
+#define AGP_FF_IS_CLIENT	2
+#define AGP_FF_IS_CONTROLLER	3
+#define AGP_FF_IS_VALID		4
 
 struct agp_file_private {
 	struct agp_file_private *next;
-- 
2.2.0

