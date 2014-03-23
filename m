Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349AbaCWSxC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 14:53:02 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:40236 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750977AbaCWSxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 14:53:01 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai8OABQtL1NbsnCH/2dsb2JhbABPAQmDBoJJfhPAIgICgQ4XdIJmHCMYgQIkEQKHfQHNRY4WCAFbhD8EmEkBilmHWIMuPASBKA
Date: Sun, 23 Mar 2014 19:54:41 +0100
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] drivers/ata/ata_piix.c: Spelling s/identify/identity
Message-Id: <20140323195441.6f80d6c9743d22bf9289e441@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/ata/ata_piix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 6334c8d..01982cb 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -975,7 +975,7 @@ static int piix_broken_suspend(void)
 		if (dmi_find_device(DMI_DEV_TYPE_OEM_STRING, oemstrs[i], NULL))
 			return 1;
 
-	/* TECRA M4 sometimes forgets its identify and reports bogus
+	/* TECRA M4 sometimes forgets its identity and reports bogus
 	 * DMI information.  As the bogus information is a bit
 	 * generic, match as many entries as possible.  This manual
 	 * matching is necessary because dmi_system_id.matches is
-- 
1.8.4.5

