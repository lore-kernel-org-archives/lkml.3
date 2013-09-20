Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105Ab3ITUJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:09:17 -0400
Received: from 87-127-191-49.static.enta.net ([87.127.191.49]:39426 "EHLO
	mail.linicks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3ITUJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:09:16 -0400
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Sep 2013 16:09:16 EDT
Date: Fri, 20 Sep 2013 20:59:39 +0100
From: Nick Warne <nick@linicks.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Correct wording in config COMPILE_TEST
Message-ID: <20130920195939.GA2353@sauron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

A small patch to correct English grammar usage.

Signed-off-by: Nick Warne <nick@linicks.net>


--- linux-3.12-rc1/init/Kconfig	2013-09-16 21:17:51.000000000 +0100
+++ linux-3.12-rc1/init/Kconfignew	2013-09-20 20:46:57.730316831 +0100
@@ -54,18 +54,19 @@
 	  directory to select the cross-compiler automatically.
 
 config COMPILE_TEST
-	bool "Compile also drivers which will not load"
+	bool "Also build drivers which will not load on this platform"
 	default n
 	help
 	  Some drivers can be compiled on a different platform than they are
-	  intended to be run on. Despite they cannot be loaded there (or even
-	  when they load they cannot be used due to missing HW support),
-	  developers still, opposing to distributors, might want to build such
-	  drivers to compile-test them.
+	  intended to be run on. Despite the fact they cannot be loaded (or
+	  even when they load they cannot be used due to missing HW
+	  support etc.), developers, differing from distributors, may need 
+	  to build such drivers to compile-test them.
 
 	  If you are a developer and want to build everything available, say Y
 	  here. If you are a user/distributor, say N here to exclude useless
-	  drivers to be distributed.
+	  drivers to be distributed.  (P.S. no drivers are useless unless you
+	  need them for testing).
 
 config LOCALVERSION
 	string "Local version - append to kernel release"


Nick
-- 
http://linicks.net/
