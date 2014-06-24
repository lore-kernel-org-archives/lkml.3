Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaFXKLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:11:10 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:54314 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206AbaFXKLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:11:08 -0400
Message-ID: <1403604665.1960.14.camel@x220>
Subject: [PATCH] USB: remove CONFIG_USB_PERSIST from Documentation
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Randy Dunlap <rdunlap@infradead.org>
Cc: linux-usb@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 24 Jun 2014 12:11:05 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2014 10:11:05.0752 (UTC) FILETIME=[9C510180:01CF8F94]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_USB_PERSIST was removed in v2.6.26. Remove a reference to it from
Documentation. That reference was a bit odd to begin with.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
"[...] under certain circumstances [...]"? Is that about
USB_QUIRK_RESET_RESUME? Anyhow, I feel this paragraph needs more work,
but that would require quite a bit of hand-holding. Perhaps Alan or Greg
would like to hold my hand here...

 Documentation/usb/power-management.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/usb/power-management.txt b/Documentation/usb/power-management.txt
index 1392b61d6ebe..90dc927f0e1e 100644
--- a/Documentation/usb/power-management.txt
+++ b/Documentation/usb/power-management.txt
@@ -304,7 +304,7 @@ using the USB Persist facility.)
 
 The reset_resume method is used by the USB Persist facility (see
 Documentation/usb/persist.txt) and it can also be used under certain
-circumstances when CONFIG_USB_PERSIST is not enabled.  Currently, if a
+circumstances when that facility is not enabled.  Currently, if a
 device is reset during a resume and the driver does not have a
 reset_resume method, the driver won't receive any notification about
 the resume.  Later kernels will call the driver's disconnect method;
-- 
1.9.3

