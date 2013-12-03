Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab3LCQJZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:09:25 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52363 "EHLO
	alan.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753631Ab3LCQJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:09:24 -0500
Subject: [PATCH] i8k: Add Dell XPLS L421X
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
From: Alan <gnomes@lxorguk.ukuu.org.uk>
Date: Tue, 03 Dec 2013 16:09:28 +0000
Message-ID: <20131203160852.1940.41800.stgit@alan.etchedpixels.co.uk>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan <alan@linux.intel.com>

(Orphaned so sending via Andrew)

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=60772
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/char/i8k.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 40cc0cf2..e6939e1 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -664,6 +664,13 @@ static struct dmi_system_id __initdata i8k_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro"),
 		},
 	},
+	{
+		.ident = "Dell XPS421",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "XPS L421X"),
+		},
+	},
         { }
 };
 

