Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184AbaJXWgp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 18:36:45 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:42005 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbaJXWgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 18:36:44 -0400
Date: Fri, 24 Oct 2014 17:34:37 -0500
From: Eric Rost <eric.rost@mybabylon.net>
To: gregkh@linuxfoundation.org, jason@lakedaemon.net, jake@lwn.net,
        antonysaraev@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 6/7] staging: skein: Removes unneeded #define
Message-ID: <c4899b7ef0a14bd8ae7432efdfe7c9edc108cf55.1414189566.git.eric.rost@mybabylon.net>
References: <cover.1414189566.git.eric.rost@mybabylon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1414189566.git.eric.rost@mybabylon.net>
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

