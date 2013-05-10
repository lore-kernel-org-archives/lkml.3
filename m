Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab3EJOvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:51:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56864 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753838Ab3EJOTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:19:44 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Ben Jencks" <ben@bjencks.net>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.77517529@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [015/118] usb/misc/appledisplay: Add 24" LED Cinema display
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Jencks <ben@bjencks.net>

commit e7d3b6e22c871ba36d052ca99bc8ceca4d546a60 upstream.

Add the Apple 24" LED Cinema display to the supported devices.

Signed-off-by: Ben Jencks <ben@bjencks.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/misc/appledisplay.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -63,6 +63,7 @@ static const struct usb_device_id appled
 	{ APPLEDISPLAY_DEVICE(0x9219) },
 	{ APPLEDISPLAY_DEVICE(0x921c) },
 	{ APPLEDISPLAY_DEVICE(0x921d) },
+	{ APPLEDISPLAY_DEVICE(0x9236) },
 
 	/* Terminating entry */
 	{ }

