Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab3HBEDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 00:03:35 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50027 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750871Ab3HBEDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 00:03:34 -0400
Message-ID: <1375416212.2034.101.camel@joe-AO722>
Subject: [PATCH resend] MAINTAINERS: Add separate section for USB NETWORKING
 DRIVERS
From: Joe Perches <joe@perches.com>
To: gregkh@linuxfoundation.org
Cc: LKML <linux-kernel@vger.kernel.org>, linux-usb <linux-usb@vger.kernel.org>
Date: Thu, 01 Aug 2013 21:03:32 -0700
In-Reply-To: <1375316960686@kroah.org>
References: <1375316960686@kroah.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several drivers in drivers/net/usb/ that
do not have specific MAINTAINERS that should have
emails forwarded to the linux-usb mailing list.

Add a section for those drivers.

Signed-off-by: Joe Perches <joe@perches.com>
---
> In the future, you do not need to send drivers/net/usb/ patches to me,
> netdev and the linux-usb mailing lists should be sufficient.

I should have done this in the first patch.
Oh well...

 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d83f70f..4af7539 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8656,6 +8656,11 @@ T:	git git://git.alsa-project.org/alsa-kernel.git
 S:	Maintained
 F:	sound/usb/midi.*
 
+USB NETWORKING DRIVERS
+L:	linux-usb@vger.kernel.org
+S:	Odd Fixes
+F:	drivers/net/usb/
+
 USB OHCI DRIVER
 M:	Alan Stern <stern@rowland.harvard.edu>
 L:	linux-usb@vger.kernel.org



