Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab3L2Cn3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:43:29 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55314 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515Ab3L2CKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:30 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Leho Kraav" <leho@kraav.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Alan Cox" <alan@linux.intel.com>
Date: Sun, 29 Dec 2013 03:08:44 +0100
Message-ID: <lsq.1388282924.508124423@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 125/185] drivers/char/i8k.c: add Dell XPLS L421X
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 9aa5b0181bdf335f0b731d8502e128a862884bcd upstream.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=60772

Signed-off-by: Alan Cox <alan@linux.intel.com>
Reported-by: Leho Kraav <leho@kraav.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/i8k.c | 7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -664,6 +664,13 @@ static struct dmi_system_id __initdata i
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
 

