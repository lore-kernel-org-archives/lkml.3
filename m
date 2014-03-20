Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbaCTMwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:52:31 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:51468 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354AbaCTMwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:52:30 -0400
Message-ID: <1395319948.25711.2.camel@x220>
Subject: [PATCH] [TRIVIAL] isdn: capi: Fix comment typo "CAPI_VERSION"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 20 Mar 2014 13:52:28 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Mar 2014 12:52:29.0110 (UTC) FILETIME=[40642D60:01CF443B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Untested.

Another option would be to drop this comment, but perhaps someone finds
it useful, somehow.

 include/uapi/linux/capi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/capi.h b/include/uapi/linux/capi.h
index 65100d6..7b145fd 100644
--- a/include/uapi/linux/capi.h
+++ b/include/uapi/linux/capi.h
@@ -102,7 +102,7 @@ typedef struct capi_manufacturer_cmd {
 
 /*
  * member contr is input for
- * CAPI_GET_MANUFACTURER, CAPI_VERSION, CAPI_GET_SERIAL
+ * CAPI_GET_MANUFACTURER, CAPI_GET_VERSION, CAPI_GET_SERIAL
  * and CAPI_GET_PROFILE
  */
 typedef union capi_ioctl_struct {
-- 
1.8.5.3

