Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbaICImq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 04:42:46 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:33057 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbaICImo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 04:42:44 -0400
MIME-Version: 1.0
From: Matteo Croce <matteo@openwrt.org>
Date: Wed, 3 Sep 2014 10:42:04 +0200
X-Google-Sender-Auth: c5szbXIg3rDMPmSvPGQMwaW_Fhg
Message-ID: <CAFnufp3DcbG1DjXjD-sTL=1wYzu9dS5r1UXxGQwQjR11zRSBfg@mail.gmail.com>
Subject: [PATCH] x86 generated files in gitignore
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add bin2c and purgatory in gitignore

Signed-off-by: Matteo Croce <matteo@openwrt.org>

--- a/arch/x86/.gitignore
+++ b/arch/x86/.gitignore
@@ -1,4 +1,5 @@
 boot/compressed/vmlinux
 tools/test_get_len
 tools/insn_sanity
-
+purgatory/kexec-purgatory.c
+purgatory/purgatory.ro
--- a/scripts/.gitignore
+++ b/scripts/.gitignore
@@ -10,3 +10,4 @@ recordmcount
 docproc
 sortextable
 asn1_compiler
+bin2c
