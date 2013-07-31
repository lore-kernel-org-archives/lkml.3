Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907Ab3GaNom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:44:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46942 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759735Ab3GaNZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:47 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "=?UTF-8?q?J=C3=B3hann=20B=2E=20Gu=C3=B0mundsson?=" 
	<johannbg@gmail.com>,
        "=?UTF-8?Q?J=C3=B3hann=20B?=.=?UTF-8?Q?=20Gu=C3=B0mundsson?=" 
	<johannbg@fedoraproject.org>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.976980322@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [59/84] USB: misc: Add Manhattan Hi-Speed USB DVI Converter to
 sisusbvga
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jóhann B. Guðmundsson <johannbg@gmail.com>

commit 58fc90db8261b571c026bb8bf23aad48a7233118 upstream.

Signed-off-by: Jóhann B. Guðmundsson <johannbg@fedoraproject.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/misc/sisusbvga/sisusb.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3247,6 +3247,7 @@ static const struct usb_device_id sisusb
 	{ USB_DEVICE(0x0711, 0x0903) },
 	{ USB_DEVICE(0x0711, 0x0918) },
 	{ USB_DEVICE(0x0711, 0x0920) },
+	{ USB_DEVICE(0x0711, 0x0950) },
 	{ USB_DEVICE(0x182d, 0x021c) },
 	{ USB_DEVICE(0x182d, 0x0269) },
 	{ }

