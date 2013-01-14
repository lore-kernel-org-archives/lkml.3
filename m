Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab3ANWuq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:50:46 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:27730 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757083Ab3ANWuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:50:44 -0500
Message-ID: <1358203840.10402.3.camel@lorien2>
Subject: [PATCH TRIVIAL] asus-wmi: Fix unused function build warning
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: corentin.chary@gmail.com, matthew.garrett@nebula.com
Cc: acpi4asus-user@lists.sourceforge.net, platform-driver-x86@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com
Date: Mon, 14 Jan 2013 15:50:40 -0700
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build warning

CC [M]  drivers/platform/x86/asus-wmi.o
drivers/platform/x86/asus-wmi.c:1356:13: warning: ‘do_nothing’ defined but not used [-Wunused-function]

Signed-off-by: Shuah Khan <shuah.khan@hp.com>
---
 drivers/platform/x86/asus-wmi.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index e41eae3..c11b242 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1353,11 +1353,6 @@ static int is_display_toggle(int code)
 	return 0;
 }
 
-static void do_nothing(void)
-{
-	return;
-}
-
 static void asus_wmi_notify(u32 value, void *context)
 {
 	struct asus_wmi *asus = context;
-- 
1.7.9.5



