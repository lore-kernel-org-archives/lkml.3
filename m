Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab3EPTTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 15:19:49 -0400
Received: from 14.mo1.mail-out.ovh.net ([178.32.97.215]:54321 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752827Ab3EPTTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 15:19:46 -0400
X-Greylist: delayed 18900 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 May 2013 15:19:46 EDT
Date: Thu, 16 May 2013 15:54:55 +0200
From: Alexandre Relange <alexandre@relange.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-iio@vger.kernel.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH] iio: Correct HID light sensor name in comments
Message-ID: <20130516135455.GA16014@Pinea-Alexandre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 16515262784402696269
X-Ovh-Remote: 80.118.215.65 (65.215.118.80.rev.sfr.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrkeegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecu
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrkeegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original driver was pasted from accelerometer driver, but the name
of the ID was not changed. This patch fixes this comment.

Signed-off-by: Alexandre Relange <alexandre@relange.org>
---
 drivers/iio/light/hid-sensor-als.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/hid-sensor-als.c b/drivers/iio/light/hid-sensor-als.c
index 80d68ff..cdc2cad 100644
--- a/drivers/iio/light/hid-sensor-als.c
+++ b/drivers/iio/light/hid-sensor-als.c
@@ -31,7 +31,7 @@
 #include "../common/hid-sensors/hid-sensor-trigger.h"
 
 /*Format: HID-SENSOR-usage_id_in_hex*/
-/*Usage ID from spec for Accelerometer-3D: 0x200041*/
+/*Usage ID from spec for Ambiant-Light: 0x200041*/
 #define DRIVER_NAME "HID-SENSOR-200041"
 
 #define CHANNEL_SCAN_INDEX_ILLUM 0
-- 
1.8.2.2

