Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab3IYHnV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 03:43:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35927 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3IYHnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:43:19 -0400
Date: Wed, 25 Sep 2013 00:42:54 -0700
From: tip-bot for Dave Jones <tipbot@zytor.com>
Message-ID: <tip-7a20c2fad61aa3624e83c671d36dbd36b2661476@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        davej@fedoraproject.org, davej@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        davej@fedoraproject.org, tglx@linutronix.de, davej@redhat.com
In-Reply-To: <20130925001344.GA13554@redhat.com>
References: <20130925001344.GA13554@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/reboot:
  Fix apparent cut-n-paste mistake in Dell reboot workaround
Git-Commit-ID: 7a20c2fad61aa3624e83c671d36dbd36b2661476
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 25 Sep 2013 00:43:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a20c2fad61aa3624e83c671d36dbd36b2661476
Gitweb:     http://git.kernel.org/tip/7a20c2fad61aa3624e83c671d36dbd36b2661476
Author:     Dave Jones <davej@redhat.com>
AuthorDate: Tue, 24 Sep 2013 20:13:44 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 25 Sep 2013 08:41:10 +0200

x86/reboot: Fix apparent cut-n-paste mistake in Dell reboot workaround

This seems to have been copied from the Optiplex 990 entry
above, but somoene forgot to change the ident text.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
Link: http://lkml.kernel.org/r/20130925001344.GA13554@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/reboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 5f4ad27..e643e74 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -352,7 +352,7 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 	},
 	{	/* Handle problems with rebooting on the Precision M6600. */
 		.callback = set_pci_reboot,
-		.ident = "Dell OptiPlex 990",
+		.ident = "Dell Precision M6600",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Precision M6600"),
