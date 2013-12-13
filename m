Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab3LMSFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 13:05:37 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:24927 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab3LMSFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 13:05:35 -0500
Message-ID: <1386957929.2867.6.camel@buesod1.americas.hpqcorp.net>
Subject: [PATCH] MAINTAINERS: add myself as gpt maintainer
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Matt Fleming <matt.fleming@intel.com>
Cc: Matt Fleming <matt@console-pimps.org>, Jens Axboe <axboe@kernel.dk>,
        Matt Domsch <Matt_Domsch@dell.com>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>
Date: Fri, 13 Dec 2013 10:05:29 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr@hp.com>

Add a new entry for the GPT standard. Any future changes will now be routed
through linux-efi.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Matt Domsch <Matt_Domsch@dell.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
This was discussed offline and both Matts are fine with me maintaining this.

 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4afcfb4..cf41aa5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3834,6 +3834,12 @@ T:	git git://linuxtv.org/media_tree.git
 S:	Maintained
 F:	drivers/media/usb/gspca/
 
+GUID PARTITION TABLE (GPT)
+M:	Davidlohr Bueso <davidlohr@hp.com>
+L:	linux-efi@vger.kernel.org
+S:	Maintained
+F:	block/partitions/efi.*
+
 STK1160 USB VIDEO CAPTURE DRIVER
 M:	Ezequiel Garcia <elezegarcia@gmail.com>
 L:	linux-media@vger.kernel.org
-- 
1.8.1.4



