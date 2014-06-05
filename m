Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbaFEE3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:29:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbaFEEWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Jaume=20Delcl=C3=B2s?= <jaume@delclos.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 190/214] Wireless: rt2x00: Add device id for Sweex LW323 to rt2800usb.c
Date: Wed,  4 Jun 2014 21:19:13 -0700
Message-Id: <20140605041704.968314942@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Jaume=20Delcl=C3=B2s?= <jaume@delclos.com>

commit 36f318bb124b231c01db6965a009f46d5731f012 upstream.

This patch adds detection for the Sweex LW323 USB wireless network card
in the rt2x00 driver (just one line in rt2800usb.c).
It applies to linux-3.7-rc3.

Signed-off-by: Jaume Delclòs <jaume@delclos.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1140,6 +1140,7 @@ static struct usb_device_id rt2800usb_de
 	{ USB_DEVICE(0x177f, 0x0153) },
 	{ USB_DEVICE(0x177f, 0x0302) },
 	{ USB_DEVICE(0x177f, 0x0313) },
+	{ USB_DEVICE(0x177f, 0x0323) },
 	/* U-Media */
 	{ USB_DEVICE(0x157e, 0x300e) },
 	{ USB_DEVICE(0x157e, 0x3013) },


