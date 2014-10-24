Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbaJXLVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 07:21:52 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:54164 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008AbaJXLVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 07:21:51 -0400
Date: Fri, 24 Oct 2014 06:19:44 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/7] staging: skein: Removes unneeded #define
Message-ID: <70a1f2485b5f4b068b60d20ed683ecfc8cd9a508.1414149238.git.eric.rost@mybabylon.net>
References: <cover.1414149238.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414149238.git.eric.rost@mybabylon.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes unneeded #define SKEIN_PORT_CODE since skein_port.h is
nonexistent.

Signed-off-by: Eric Rost <eric.rost@mybabylon.net>
---
 drivers/staging/skein/skein_base.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/skein/skein_base.c b/drivers/staging/skein/skein_base.c
index e0994ea..ebc436a 100644
--- a/drivers/staging/skein/skein_base.c
+++ b/drivers/staging/skein/skein_base.c
@@ -8,8 +8,6 @@
 **
 ************************************************************************/
 
-#define  SKEIN_PORT_CODE /* instantiate any code in skein_port.h */
-
 #include <linux/string.h>       /* get the memcpy/memset functions */
 #include <linux/export.h>
 #include "skein_base.h" /* get the Skein API definitions   */
-- 
2.1.1

