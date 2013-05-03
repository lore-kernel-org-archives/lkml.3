Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763397Ab3ECURA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:17:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729Ab3ECUQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:16:59 -0400
Date: Fri, 3 May 2013 16:16:56 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: dhowells@redhat.com
Subject: Add missing MODULE_LICENSE tag to oid_registry
Message-ID: <20130503201656.GA12510@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, dhowells@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if CONFIG_OID_REGISTRY=m

[  241.094450] oid_registry: module license 'unspecified' taints kernel.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/lib/oid_registry.c b/lib/oid_registry.c
index d8de11f..6eff319 100644
--- a/lib/oid_registry.c
+++ b/lib/oid_registry.c
@@ -9,6 +9,7 @@
  * 2 of the Licence, or (at your option) any later version.
  */
 
+#include <linux/module.h>
 #include <linux/export.h>
 #include <linux/oid_registry.h>
 #include <linux/kernel.h>
@@ -168,3 +169,5 @@ int sprint_OID(enum OID oid, char *buffer, size_t bufsize)
 	return ret;
 }
 EXPORT_SYMBOL_GPL(sprint_OID);
+
+MODULE_LICENSE("GPL");
