Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967272Ab3HIBme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:42:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967076Ab3HIBls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:41:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [ 11/22] MAINTAINERS: fix up stable_kernel_rules.txt location
Date: Thu,  8 Aug 2013 18:41:27 -0700
Message-Id: <20130809013951.628124855@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809013949.226228694@linuxfoundation.org>
References: <20130809013949.226228694@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

There was a mismerge of 7b175c46720f8e6b92801bb634c93d1016f80c62 for the
3.0 kernel, so this fixes it up.

Also mark the stable stuff "Supported", as it is.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 MAINTAINERS |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5725,7 +5725,6 @@ P:	Vincent Sanders <vince@simtec.co.uk>
 M:	Simtec Linux Team <linux@simtec.co.uk>
 W:	http://www.simtec.co.uk/products/EB110ATX/
 S:	Supported
-F:	Documentation/stable_kernel_rules.txt
 
 SIMTEC EB2410ITX (BAST)
 P:	Ben Dooks
@@ -6041,7 +6040,8 @@ F:	arch/alpha/kernel/srm_env.c
 STABLE BRANCH
 M:	Greg Kroah-Hartman <greg@kroah.com>
 L:	stable@vger.kernel.org
-S:	Maintained
+S:	Supported
+F:	Documentation/stable_kernel_rules.txt
 
 STAGING SUBSYSTEM
 M:	Greg Kroah-Hartman <gregkh@suse.de>


