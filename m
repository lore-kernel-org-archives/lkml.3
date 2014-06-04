Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaFDTUJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 15:20:09 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:57457 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750780AbaFDTUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 15:20:07 -0400
Date: Wed, 4 Jun 2014 14:20:03 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: akpm@linux-foundation.org
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>, mpm@selenic.com,
        David Rientjes <rientjes@google.com>, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH] SLAB Maintainer update
Message-ID: <alpine.DEB.2.10.1406041417290.14004@gentwo.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed in various threads on the side:


Remove one inactive maintainer, add two new ones and update
my email address. Plus add Andrew. And fix the glob to include
files like mm/slab_common.c

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/MAINTAINERS
===================================================================
--- linux.orig/MAINTAINERS	2014-06-04 14:13:49.404373350 -0500
+++ linux/MAINTAINERS	2014-06-04 14:16:51.804786701 -0500
@@ -8104,13 +8104,15 @@
 F:	drivers/usb/misc/sisusbvga/

 SLAB ALLOCATOR
-M:	Christoph Lameter <cl@linux-foundation.org>
+M:	Christoph Lameter <cl@linux.com>
 M:	Pekka Enberg <penberg@kernel.org>
-M:	Matt Mackall <mpm@selenic.com>
+M:	David Rientjes <rientjes@google.com>
+M:	Joonsoo Kim <iamjoonsoo.kim@lge.com>
+M:	Andrew Morton <akpm@linux-foundation.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/sl?b*.h
-F:	mm/sl?b.c
+F:	mm/sl?b*

 SLEEPABLE READ-COPY UPDATE (SRCU)
 M:	Lai Jiangshan <laijs@cn.fujitsu.com>
Index: linux/CREDITS
===================================================================
--- linux.orig/CREDITS	2014-06-04 14:13:49.404373350 -0500
+++ linux/CREDITS	2014-06-04 14:13:49.400373430 -0500
@@ -9,6 +9,10 @@
 			Linus
 ----------

+M: Matt Mackal
+E: mpm@selenic.com
+D: SLOB slab allocator
+
 N: Matti Aarnio
 E: mea@nic.funet.fi
 D: Alpha systems hacking, IPv6 and other network related stuff
