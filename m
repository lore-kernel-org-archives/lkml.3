Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab3CYTmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 15:42:10 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:50571 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758873Ab3CYTmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 15:42:08 -0400
Message-ID: <1364240526.1390.291.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] fix typo "CONFIG_MODULE_SIG_ENFORCE"
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 25 Mar 2013 20:42:06 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2013 19:42:07.0662 (UTC) FILETIME=[D5A394E0:01CE2990]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 Documentation/kernel-parameters.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..72bb2a8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1625,7 +1625,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	module.sig_enforce
 			[KNL] When CONFIG_MODULE_SIG is set, this means that
 			modules without (valid) signatures will fail to load.
-			Note that if CONFIG_MODULE_SIG_ENFORCE is set, that
+			Note that if CONFIG_MODULE_SIG_FORCE is set, that
 			is always true, so this option does nothing.
 
 	mousedev.tap_time=
-- 
1.7.11.7



