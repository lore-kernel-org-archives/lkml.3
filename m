Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088AbaGRDqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 23:46:37 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:51086 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759706AbaGRDqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 23:46:35 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: sfr@canb.auug.org.au, rdunlap@infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH/linux-next] Documentation:Docbook: Fix file locations in gadget.tmpl
Date: Fri, 18 Jul 2014 12:46:09 +0900
Message-Id: <1405655169-23804-2-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.0.1.537.g81e776d
In-Reply-To: <1405655169-23804-1-git-send-email-standby24x7@gmail.com>
References: <1405655169-23804-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of file location changes by commit 5ed4ac73e5975,
make xmldocs failed because of missing files.
Fix file paths in gadget.tmpl file.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/DocBook/gadget.tmpl | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/Documentation/DocBook/gadget.tmpl b/Documentation/DocBook/gadget.tmpl
index 2c425d7..6416292 100644
--- a/Documentation/DocBook/gadget.tmpl
+++ b/Documentation/DocBook/gadget.tmpl
@@ -556,11 +556,11 @@ been converted to this framework.
 Near-term plans include converting all of them, except for "gadgetfs".
 </para>
 
-!Edrivers/usb/gadget/f_acm.c
-!Edrivers/usb/gadget/f_ecm.c
-!Edrivers/usb/gadget/f_subset.c
-!Edrivers/usb/gadget/f_obex.c
-!Edrivers/usb/gadget/f_serial.c
+!Edrivers/usb/gadget/function/f_acm.c
+!Edrivers/usb/gadget/function/f_ecm.c
+!Edrivers/usb/gadget/function/f_subset.c
+!Edrivers/usb/gadget/function/f_obex.c
+!Edrivers/usb/gadget/function/f_serial.c
 
 </sect1>
 
-- 
2.0.1.537.g81e776d

