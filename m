Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3JaB5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 21:57:40 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55161 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab3JaB5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 21:57:38 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: andrzej.p@samsung.com, trivial@kernel.org, gregkh@linuxfoundation.org,
        rdunlap@infradead.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        kyungmin.park@samsung.com
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] doc: usb: Fix typo in Documentation/usb/gadget_configs.txt
Date: Thu, 31 Oct 2013 10:57:28 +0900
Message-Id: <1383184648-27765-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in Documentation/usb/gadget_configs.txt

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/usb/gadget_configfs.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/usb/gadget_configfs.txt b/Documentation/usb/gadget_configfs.txt
index 8ec2a67..4cf53e4 100644
--- a/Documentation/usb/gadget_configfs.txt
+++ b/Documentation/usb/gadget_configfs.txt
@@ -26,7 +26,7 @@ Linux provides a number of functions for gadgets to use.
 Creating a gadget means deciding what configurations there will be
 and which functions each configuration will provide.
 
-Configfs (please see Documentation/filesystems/configfs/*) lends itslef nicely
+Configfs (please see Documentation/filesystems/configfs/*) lends itself nicely
 for the purpose of telling the kernel about the above mentioned decision.
 This document is about how to do it.
 
@@ -99,7 +99,7 @@ directories must be created:
 $ mkdir configs/<name>.<number>
 
 where <name> can be any string which is legal in a filesystem and the
-<numebr> is the configuration's number, e.g.:
+<number> is the configuration's number, e.g.:
 
 $ mkdir configs/c.1
 
@@ -327,7 +327,7 @@ from the buffer to the cs), but it is up to the implementer of the
 two functions to decide what they actually do.
 
 typedef struct configured_structure cs;
-typedef struc specific_attribute sa;
+typedef struct specific_attribute sa;
 
                                        sa
                        +----------------------------------+
-- 
1.8.4.1.600.g3d092bf

