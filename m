Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757640AbaFZBz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 21:55:29 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:61008 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757281AbaFZBzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 21:55:25 -0400
MIME-Version: 1.0
Date: Thu, 26 Jun 2014 09:55:24 +0800
Message-ID: <CAJKoSVSBBawWBzOmQixTf+DZpWLk1YyNao2-5ESM1-VdTWnFpg@mail.gmail.com>
Subject: [PATCH] staging: wlan-ng/hfa384x_usb.c: add blank line after declarations
From: Cheng-Wei Lee <lee.rhapsody@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sherif Shehab Aldin <shehabaldin.sherif@gmail.com>,
        Avinash Kumar <avi.kp.137@gmail.com>,
        Peter Senna Tschudin <peter.senna@gmail.com>
Cc: devel <devel@driverdev.osuosl.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl issues in hfa384x_usb.c:
WARNING: Missing a blank line after declarations

Signed-off-by: Quentin Lee <lee.rhapsody@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c
b/drivers/staging/wlan-ng/hfa384x_usb.c
index 98343ff7..07cee56 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -3705,6 +3705,7 @@ static void hfa384x_usbout_callback(struct urb *urb)
                case -EPIPE:
                        {
                                hfa384x_t *hw = wlandev->priv;
+
                                netdev_warn(hw->wlandev->netdev,
                                            "%s tx pipe stalled:
requesting reset\n",
                                            wlandev->netdev->name);
--
1.7.9.5
