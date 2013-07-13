Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab3GMQoM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 12:44:12 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:50984 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041Ab3GMQoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 12:44:11 -0400
Message-ID: <1373733849.1359.20.camel@x61.thuisdomein>
Subject: [PATCH v2] staging/lustre/libcfs: staging/lustre/libcfs: drop bogus
 Kconfig default
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Sat, 13 Jul 2013 18:44:09 +0200
In-Reply-To: <20130713160716.GA2279@kroah.com>
References: <1373726446.1359.17.camel@x61.thuisdomein>
	 <20130713160716.GA2279@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2013 16:44:10.0055 (UTC) FILETIME=[32BA8D70:01CE7FE8]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4b5b4c7222 ("staging/lustre/libcfs: restore LINVRNT") added
"default false" to this Kconfig file. It was obviously meant to use
"default n" here. But we might as well drop this line, as a Kconfig bool
defaults to 'n' anyway.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) v2: remove the default entirely, as Greg suggested.

1) Still tested with "make menuconfig" only. 

 drivers/staging/lustre/lustre/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
index e0eb830..173d21e 100644
--- a/drivers/staging/lustre/lustre/Kconfig
+++ b/drivers/staging/lustre/lustre/Kconfig
@@ -43,7 +43,6 @@ config LUSTRE_OBD_MAX_IOCTL_BUFFER
 config LUSTRE_DEBUG_EXPENSIVE_CHECK
 	bool "Enable Lustre DEBUG checks"
 	depends on LUSTRE_FS
-	default false
 	help
 	  This option is mainly for debug purpose. It enables Lustre code to do
 	  expensive checks that may have a performance impact.
-- 
1.8.1.4

