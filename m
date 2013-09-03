Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760923Ab3ICVSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 17:18:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877Ab3ICVSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 17:18:46 -0400
Date: Tue, 3 Sep 2013 17:18:38 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: gregkh@linuxfoundation.org
Subject: fix typo in usb serial simple driver Kconfig
Message-ID: <20130903211838.GC2247@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	gregkh@linuxfoundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/usb/serial/Kconfig b/drivers/usb/serial/Kconfig
index c454bfa..ddb9c51 100644
--- a/drivers/usb/serial/Kconfig
+++ b/drivers/usb/serial/Kconfig
@@ -60,7 +60,7 @@ config USB_SERIAL_SIMPLE
 		- Suunto ANT+ USB device.
 		- Fundamental Software dongle.
 		- HP4x calculators
-		- a number of Motoroloa phones
+		- a number of Motorola phones
 		- Siemens USB/MPI adapter.
 		- ViVOtech ViVOpay USB device.
 		- Infineon Modem Flashloader USB interface
