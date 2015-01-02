Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750908AbbABFLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 00:11:25 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49248 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbbABFLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 00:11:19 -0500
Date: Fri, 2 Jan 2015 06:11:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: trivial@kernel.org, kernel list <linux-kernel@vger.kernel.org>
Subject: [trivial PATCH] use capital BIOS in comment
Message-ID: <20150102051116.GD4873@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use capital BIOS in comment. Its cleaner, and allows diference
between BIOS and BIOs.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 66dba36..452f904 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -582,7 +582,7 @@ void __init init_mem_mapping(void)
  *
  *
  * On x86, access has to be given to the first megabyte of ram because that area
- * contains bios code and data regions used by X and dosemu and similar apps.
+ * contains BIOS code and data regions used by X and dosemu and similar apps.
  * Access has to be given to non-kernel-ram areas as well, these contain the PCI
  * mmio resources as well as potential bios/acpi data regions.
  */

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
