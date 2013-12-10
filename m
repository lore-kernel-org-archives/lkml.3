Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab3LJIGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:06:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab3LJICr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:02:47 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, Leho Kraav <leho@kraav.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3.12 62/62] drivers/char/i8k.c: add Dell XPLS L421X
Date: Tue, 10 Dec 2013 00:01:33 -0800
Message-Id: <20131210080101.746168287@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131210080057.415644748@linuxfoundation.org>
References: <20131210080057.415644748@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 9aa5b0181bdf335f0b731d8502e128a862884bcd upstream.

Addresses https://bugzilla.kernel.org/show_bug.cgi?id=60772

Signed-off-by: Alan Cox <alan@linux.intel.com>
Reported-by: Leho Kraav <leho@kraav.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/i8k.c |    7 +++++++
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
 


