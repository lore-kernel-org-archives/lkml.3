Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab3HTRaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:30:17 -0400
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:44594 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751367Ab3HTRaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:30:15 -0400
X-Greylist: Passed host: 188.104.12.42
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-04.arcor-online.net 94C22A9D2B
X-Greylist: Passed host: 188.104.12.42
X-Greylist: Passed host: 188.104.12.42
X-Greylist: Passed host: 188.104.12.42
X-Greylist: Passed host: 188.104.12.42
X-Greylist: Passed host: 188.104.12.42
Subject: [PATCH] MAINTAINERS: Adding Roccat drivers
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Aug 2013 19:30:12 +0200
Message-ID: <1377019812.2474.2.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding maintainer for Roccat hid drivers

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



