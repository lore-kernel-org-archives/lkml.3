Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab3E0Jiu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:38:50 -0400
Received: from linuxdingsda.de ([87.106.20.67]:48471 "EHLO serverteil.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755115Ab3E0Jis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:38:48 -0400
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Mon, 27 May 2013 05:38:48 EDT
Message-ID: <51A327A4.7020908@linuxdingsda.de>
Date: Mon, 27 May 2013 11:30:12 +0200
From: Tobias Winter <tobias@linuxdingsda.de>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-usb@vger.kernel.org
CC: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Raise the maximum number of usb-serial devices to 256
References: <519F7195.8090306@linuxdingsda.de> <20130524172354.GA1402@kroah.com>
In-Reply-To: <20130524172354.GA1402@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raise the maximum number of usb-serial devices to 256, which is the
actual limit supported by the codebase.

Signed-off-by: Jakob-Tobias Winter <tobias@linuxdingsda.de>
Tested-by: Jakob-Tobias Winter <tobias@linuxdingsda.de>

---
 include/linux/usb/serial.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 302ddf5..c0ce5ed 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -20,7 +20,7 @@
 #include <linux/kfifo.h>

 #define SERIAL_TTY_MAJOR       188     /* Nice legal number now */
-#define SERIAL_TTY_MINORS      254     /* loads of devices :) */
+#define SERIAL_TTY_MINORS      256     /* loads of devices :) */
 #define SERIAL_TTY_NO_MINOR    255     /* No minor was assigned */

 /* The maximum number of ports one device can grab at once */
-- 
1.7.10.4

