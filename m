Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaCIEcO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 23:32:14 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51394 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaCIEcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 23:32:13 -0500
From: Nick Davies <git@nicolasdavies.com.au>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Nick Davies <git@nicolasdavies.com.au>
Subject: [PATCH] Staging: comedi: ni_tio Fixed whitespace coding style warnings
Date: Sun,  9 Mar 2014 15:31:49 +1100
Message-Id: <1394339509-11851-1-git-send-email-git@nicolasdavies.com.au>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style warnings in ni_tio.h which had an extra space
after the function pointer name.

Signed-off-by: Nick Davies <git@nicolasdavies.com.au>
---
 drivers/staging/comedi/drivers/ni_tio.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/ni_tio.h b/drivers/staging/comedi/drivers/ni_tio.h
index 68378da..1056bf0 100644
--- a/drivers/staging/comedi/drivers/ni_tio.h
+++ b/drivers/staging/comedi/drivers/ni_tio.h
@@ -115,10 +115,10 @@ struct ni_gpct {
 
 struct ni_gpct_device {
 	struct comedi_device *dev;
-	void (*write_register) (struct ni_gpct *counter, unsigned bits,
-				enum ni_gpct_register reg);
-	unsigned (*read_register) (struct ni_gpct *counter,
-				   enum ni_gpct_register reg);
+	void (*write_register)(struct ni_gpct *counter, unsigned bits,
+			       enum ni_gpct_register reg);
+	unsigned (*read_register)(struct ni_gpct *counter,
+				  enum ni_gpct_register reg);
 	enum ni_gpct_variant variant;
 	struct ni_gpct *counters;
 	unsigned num_counters;
-- 
1.9.0

