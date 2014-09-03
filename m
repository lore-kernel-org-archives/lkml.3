Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989AbaICWTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:19:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933936AbaICWS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Holger Paradies <retabell@gmx.de>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 3.16 104/125] staging/rtl8188eu: add 0df6:0076 Sitecom Europe B.V.
Date: Wed,  3 Sep 2014 15:07:41 -0700
Message-Id: <20140903220626.823716047@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Holger Paradies <retabell@gmx.de>

commit 8626d524ef08f10fccc0c41e5f75aef8235edf47 upstream.

The stick is not recognized.
This dongle uses r8188eu but usb-id is missing.
3.16.0

Signed-off-by: Holger Paradies <retabell@gmx.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8188eu/os_dep/usb_intf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
@@ -57,6 +57,7 @@ static struct usb_device_id rtw_usb_id_t
 	{USB_DEVICE(0x07b8, 0x8179)}, /* Abocom - Abocom */
 	{USB_DEVICE(0x2001, 0x330F)}, /* DLink DWA-125 REV D1 */
 	{USB_DEVICE(0x2001, 0x3310)}, /* Dlink DWA-123 REV D1 */
+	{USB_DEVICE(0x0df6, 0x0076)}, /* Sitecom N150 v2 */
 	{}	/* Terminating entry */
 };
 


