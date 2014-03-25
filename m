Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaCYLSi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 07:18:38 -0400
Received: from andre.telenet-ops.be ([195.130.132.53]:58580 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaCYLSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 07:18:35 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@infradead.org>,
        Joe Perches <joe@perches.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] vsprintf: Document %p parameters passed by reference
Date: Tue, 25 Mar 2014 12:18:23 +0100
Message-Id: <1395746303-16967-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Make sure all %p extensions that take parameters by references are
documented to do so.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 Documentation/printk-formats.txt |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
index 6f4eb322ffaf..00d5c43e5d14 100644
--- a/Documentation/printk-formats.txt
+++ b/Documentation/printk-formats.txt
@@ -54,6 +54,7 @@ Struct Resources:
 
 	For printing struct resources. The 'R' and 'r' specifiers result in a
 	printed resource with ('R') or without ('r') a decoded flags member.
+	Passed by reference.
 
 Physical addresses types phys_addr_t:
 
@@ -100,6 +101,8 @@ MAC/FDDI addresses:
 	specifier to use reversed byte order suitable for visual interpretation
 	of Bluetooth addresses which are in the little endian order.
 
+	Passed by reference.
+
 IPv4 addresses:
 
 	%pI4	1.2.3.4
@@ -114,6 +117,8 @@ IPv4 addresses:
 	host, network, big or little endian order addresses respectively. Where
 	no specifier is provided the default network/big endian order is used.
 
+	Passed by reference.
+
 IPv6 addresses:
 
 	%pI6	0001:0002:0003:0004:0005:0006:0007:0008
@@ -128,6 +133,8 @@ IPv6 addresses:
 	print a compressed IPv6 address as described by
 	http://tools.ietf.org/html/rfc5952
 
+	Passed by reference.
+
 IPv4/IPv6 addresses (generic, with port, flowinfo, scope):
 
 	%pIS	1.2.3.4		or 0001:0002:0003:0004:0005:0006:0007:0008
@@ -154,6 +161,8 @@ IPv4/IPv6 addresses (generic, with port, flowinfo, scope):
 	specifiers can be used as well and are ignored in case of an IPv6
 	address.
 
+	Passed by reference.
+
 	Further examples:
 
 	%pISfc		1.2.3.4		or [1:2:3:4:5:6:7:8]/123456789
@@ -175,6 +184,8 @@ UUID/GUID addresses:
 	Where no additional specifiers are used the default little endian
 	order with lower case hex characters will be printed.
 
+	Passed by reference.
+
 dentry names:
 	%pd{,2,3,4}
 	%pD{,2,3,4}
@@ -184,6 +195,8 @@ dentry names:
 	equivalent of %s dentry->d_name.name we used to use, %pd<n> prints
 	n last components.  %pD does the same thing for struct file.
 
+	Passed by reference.
+
 struct va_format:
 
 	%pV
@@ -199,6 +212,8 @@ struct va_format:
 	Do not use this feature without some mechanism to verify the
 	correctness of the format string and va_list arguments.
 
+	Passed by reference.
+
 u64 SHOULD be printed with %llu/%llx, (unsigned long long):
 
 	printk("%llu", u64_var);
-- 
1.7.9.5

