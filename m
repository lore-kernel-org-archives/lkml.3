Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933823Ab3CRVpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:45:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45798 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab3CRVHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?ISO-8859-15?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [ 04/48] USB: option: add Huawei E5331
Date: Mon, 18 Mar 2013 14:08:12 -0700
Message-Id: <20130318210810.562913521@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210810.247845918@linuxfoundation.org>
References: <20130318210810.247845918@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit daec90e7382cbd0e73eb6861109b3da91e5ab1f3 upstream.

Another device using CDC ACM with vendor specific protocol to mark
serial functions.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/option.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -579,6 +579,7 @@ static const struct usb_device_id option
 	{ USB_DEVICE(QUANTA_VENDOR_ID, 0xea42),
 		.driver_info = (kernel_ulong_t)&net_intf4_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1c05, USB_CLASS_COMM, 0x02, 0xff) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1c1f, USB_CLASS_COMM, 0x02, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, 0x1c23, USB_CLASS_COMM, 0x02, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(HUAWEI_VENDOR_ID, HUAWEI_PRODUCT_E173, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t) &net_intf1_blacklist },


