Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaIZKXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:23:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856AbaIZJqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:13 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Holger Paradies <retabell@gmx.de>,
        Larry Finger <Larry.Finger@lwfinger.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 018/142] staging/rtl8188eu: add 0df6:0076 Sitecom Europe B.V.
Date: Fri, 26 Sep 2014 11:43:49 +0200
Message-Id: <09357cf4c4696205fe6c8e8131fa7c6c3241cfc1.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Holger Paradies <retabell@gmx.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8626d524ef08f10fccc0c41e5f75aef8235edf47 upstream.

The stick is not recognized.
This dongle uses r8188eu but usb-id is missing.
3.16.0

Signed-off-by: Holger Paradies <retabell@gmx.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
index 85f692ddd992..899c91bd1ad1 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -56,6 +56,7 @@ static struct usb_device_id rtw_usb_id_tbl[] = {
 	{USB_DEVICE(0x07b8, 0x8179)}, /* Abocom - Abocom */
 	{USB_DEVICE(0x2001, 0x330F)}, /* DLink DWA-125 REV D1 */
 	{USB_DEVICE(0x2001, 0x3310)}, /* Dlink DWA-123 REV D1 */
+	{USB_DEVICE(0x0df6, 0x0076)}, /* Sitecom N150 v2 */
 	{}	/* Terminating entry */
 };
 
-- 
2.1.0

