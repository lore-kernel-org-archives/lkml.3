Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab3C2VwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 17:52:23 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:47032 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051Ab3C2VwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 17:52:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: PNP: List Rafael Wysocki as a maintainer
Date: Fri, 29 Mar 2013 22:59:53 +0100
Message-ID: <1772625.se04ulK18U@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc4+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The Adam Belay's e-mail address in MAINTAINERS under PNP SUPPORT
is not valid any more and I started to maintain that code in the
meantime as a matter of fact, so list myself as a maintainer of it
along with Bjorn and remove the Adam's entry from it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-pm/MAINTAINERS
===================================================================
--- linux-pm.orig/MAINTAINERS
+++ linux-pm/MAINTAINERS
@@ -6209,7 +6209,7 @@ F:	include/linux/power_supply.h
 F:	drivers/power/
 
 PNP SUPPORT
-M:	Adam Belay <abelay@mit.edu>
+M:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
 M:	Bjorn Helgaas <bhelgaas@google.com>
 S:	Maintained
 F:	drivers/pnp/

