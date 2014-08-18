Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaHRJfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:35:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42783 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaHRJfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:35:05 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 068/137] [media] gspca_pac7302: Add new usb-id for Genius i-Look 317
Date: Mon, 18 Aug 2014 10:32:09 +0100
Message-Id: <1408354398-10226-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 242841d3d71191348f98310e2d2001e1001d8630 upstream.

Tested-and-reported-by: yullaw <yullaw@mageia.cz>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/usb/gspca/pac7302.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/gspca/pac7302.c b/drivers/media/usb/gspca/pac7302.c
index a91509643563..0d4be1d840ab 100644
--- a/drivers/media/usb/gspca/pac7302.c
+++ b/drivers/media/usb/gspca/pac7302.c
@@ -928,6 +928,7 @@ static const struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x093a, 0x2620)},
 	{USB_DEVICE(0x093a, 0x2621)},
 	{USB_DEVICE(0x093a, 0x2622), .driver_info = FL_VFLIP},
+	{USB_DEVICE(0x093a, 0x2623), .driver_info = FL_VFLIP},
 	{USB_DEVICE(0x093a, 0x2624), .driver_info = FL_VFLIP},
 	{USB_DEVICE(0x093a, 0x2625)},
 	{USB_DEVICE(0x093a, 0x2626)},
-- 
1.9.1

