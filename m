Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbbAZNyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:54:37 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:43809 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbbAZNyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:54:33 -0500
Date: Mon, 26 Jan 2015 21:18:37 +0800
From: Simon Guo <wei.guo.simon@gmail.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        wei.guo.simon@gmail.com
Subject: [PATCH 3.19.0-rc5 03/03] STAGING: Fix pcl818.c coding style issue:
 no space before tabs
Message-ID: <20150126131836.GC9183@thunderCat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct one coding style problem(detected by checkpatch.pl) in pcl818.c.
- please, no space before tabs

Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
---
 drivers/staging/comedi/drivers/pcl818.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index bc8493f..4104f47 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -83,7 +83,7 @@
  *               2=             +/-2.5V
  *               3=             +/-1V
  *               4=             +/-0.5V
- *               5=  	     user defined bipolar
+ *               5=          user defined bipolar
  *               6=	     0-10V
  *               7=	     0-5V
  *               8=	     0-2V
-- 
1.8.1.2

