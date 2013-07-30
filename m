Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728Ab3G3Jhw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:37:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53383 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655Ab3G3Jdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:55 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Enrico Mioso <mrkiko.rs@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 094/106] usb: serial: option: Add ONYX 3G device support
Date: Tue, 30 Jul 2013 10:31:53 +0100
Message-Id: <1375176725-5825-95-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enrico Mioso <mrkiko.rs@gmail.com>

commit 63b5df963f52ccbab6fabedf05b7ac6b465789a4 upstream.

This patch adds support for the ONYX 3G device (version 1) from ALFA
NETWORK.

Signed-off-by: Enrico Mioso <mrkiko.rs@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/option.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 5e3e4b6..d2d4a48 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -798,6 +798,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE(KYOCERA_VENDOR_ID, KYOCERA_PRODUCT_KPC680) },
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6000)}, /* ZTE AC8700 */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
+	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x0023)}, /* ONYX 3G device */
 	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x9000)}, /* SIMCom SIM5218 */
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6280) }, /* BP3-USB & BP3-EXT HSDPA */
 	{ USB_DEVICE(CMOTECH_VENDOR_ID, CMOTECH_PRODUCT_6008) },
-- 
1.8.3.2

