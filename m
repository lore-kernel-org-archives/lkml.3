Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310Ab3AQNxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:53:20 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:41602 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3AQNxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:53:19 -0500
Date: Thu, 17 Jan 2013 08:53:09 -0500
From: Jake Champlin <jake.champlin.27@gmail.com>
To: abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, gregh@linuxfoundation.org,
        jake.champlin.27@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: Comedi: ni_tio: Fixed spacing issue
Message-ID: <20130117135304.GA1943@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue from spaces to tabs.

Signed-off-by: Jake Champlin <jake.champlin.27@gmail.com>
---
 drivers/staging/comedi/drivers/ni_tio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_tio.c b/drivers/staging/comedi/drivers/ni_tio.c
index 98f8789..2252877 100644
--- a/drivers/staging/comedi/drivers/ni_tio.c
+++ b/drivers/staging/comedi/drivers/ni_tio.c
@@ -276,7 +276,7 @@ static inline unsigned NI_660x_RTSI_Second_Gate_Select(unsigned n)
 }
 
 static const unsigned int counter_status_mask =
-    COMEDI_COUNTER_ARMED | COMEDI_COUNTER_COUNTING;
+	COMEDI_COUNTER_ARMED | COMEDI_COUNTER_COUNTING;
 
 static int __init ni_tio_init_module(void)
 {
-- 
1.8.1.1


-- 
Jake Champlin
jake.champlin.27@gmail.com

