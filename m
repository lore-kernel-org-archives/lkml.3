Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab3IEEgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 00:36:07 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:55937 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753088Ab3IEEgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 00:36:04 -0400
X-Greylist: Passed host: 92.74.37.206
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-16.arcor-online.net 82DB78253
X-Greylist: Passed host: 92.74.37.206
Subject: [PATCH] HID: roccat: MAINTAINERS: Adding Roccat drivers 2nd try
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Sep 2013 06:36:01 +0200
Message-ID: <1378355761.2457.8.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding maintainer for Roccat hid drivers

I sent this patch some weeks ago, seemingly unnoticed.
Maybe I have more luck via Jiri's hid repo.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 MAINTAINERS |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 9705318..55d946b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6921,6 +6921,14 @@ M:	Maxim Levitsky <maximlevitsky@gmail.com>
 S:	Maintained
 F:	drivers/memstick/host/r592.*
 
+ROCCAT DRIVERS
+M:	Stefan Achatz <erazor_de@users.sourceforge.net>
+W:	http://sourceforge.net/projects/roccat/
+S:	Maintained
+F:	drivers/hid/hid-roccat*
+F:	include/linux/hid-roccat*
+F:	Documentation/ABI/*/sysfs-driver-hid-roccat*
+
 ROCKETPORT DRIVER
 P:	Comtrol Corp.
 W:	http://www.comtrol.com
-- 
1.7.3.4




