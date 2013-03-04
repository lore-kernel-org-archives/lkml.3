Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab3CDJ6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:58:18 -0500
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:47481 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124Ab3CDJ6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:58:16 -0500
Message-ID: <1362391043.6156.2.camel@nexus.lab.ntt.co.jp>
Subject: [PATCH] scripts/mod: add device table offsets file to list of files
 to clean
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando_b1@lab.ntt.co.jp>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 04 Mar 2013 18:57:23 +0900
Organization: NTT Open Source Software Center
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>

This file is generated so it does not get cleaned automagically. In other words
we need to added to the clean-files list.

Signed-off-by: Fernando Luis Vázquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-3.9-rc1-orig/scripts/mod/Makefile linux-3.9-rc1/scripts/mod/Makefile
--- linux-3.9-rc1-orig/scripts/mod/Makefile	2013-03-04 16:09:29.297904000 +0900
+++ linux-3.9-rc1/scripts/mod/Makefile	2013-03-04 18:06:16.359389000 +0900
@@ -49,3 +49,5 @@ $(obj)/elfconfig.h: $(obj)/empty.o $(obj
 	$(call if_changed,elfconfig)
 
 targets += elfconfig.h
+
+clean-files	:= $(devicetable-offsets-file)


