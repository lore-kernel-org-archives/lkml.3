Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759295AbbA0SRo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:17:44 -0500
Received: from smtp73.iad3a.emailsrvr.com ([173.203.187.73]:53194 "EHLO
	smtp73.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759159AbbA0SRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:17:15 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 5/6] staging: comedi: comedi_compat32.c: align some comments
Date: Tue, 27 Jan 2015 18:16:55 +0000
Message-Id: <1422382616-6884-6-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422382616-6884-1-git-send-email-abbotti@mev.co.uk>
References: <1422373824-12793-1-git-send-email-abbotti@mev.co.uk>
 <1422382616-6884-1-git-send-email-abbotti@mev.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Align some comments attached to members of the 32-bit compatibility
structure definitions.  These comments describe the original pointer
types that are being represented by a `compat_uptr_t`.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
v2: no change
---
 drivers/staging/comedi/comedi_compat32.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/comedi_compat32.c b/drivers/staging/comedi/comedi_compat32.c
index acbacff..0eab6c6 100644
--- a/drivers/staging/comedi/comedi_compat32.c
+++ b/drivers/staging/comedi/comedi_compat32.c
@@ -43,7 +43,7 @@
 struct comedi32_chaninfo_struct {
 	unsigned int subdev;
 	compat_uptr_t maxdata_list;	/* 32-bit 'unsigned int *' */
-	compat_uptr_t flaglist;	/* 32-bit 'unsigned int *' */
+	compat_uptr_t flaglist;		/* 32-bit 'unsigned int *' */
 	compat_uptr_t rangelist;	/* 32-bit 'unsigned int *' */
 	unsigned int unused[4];
 };
@@ -66,16 +66,16 @@ struct comedi32_cmd_struct {
 	unsigned int scan_end_arg;
 	unsigned int stop_src;
 	unsigned int stop_arg;
-	compat_uptr_t chanlist;	/* 32-bit 'unsigned int *' */
+	compat_uptr_t chanlist;		/* 32-bit 'unsigned int *' */
 	unsigned int chanlist_len;
-	compat_uptr_t data;	/* 32-bit 'short *' */
+	compat_uptr_t data;		/* 32-bit 'short *' */
 	unsigned int data_len;
 };
 
 struct comedi32_insn_struct {
 	unsigned int insn;
 	unsigned int n;
-	compat_uptr_t data;	/* 32-bit 'unsigned int *' */
+	compat_uptr_t data;		/* 32-bit 'unsigned int *' */
 	unsigned int subdev;
 	unsigned int chanspec;
 	unsigned int unused[3];
@@ -83,7 +83,7 @@ struct comedi32_insn_struct {
 
 struct comedi32_insnlist_struct {
 	unsigned int n_insns;
-	compat_uptr_t insns;	/* 32-bit 'struct comedi_insn *' */
+	compat_uptr_t insns;		/* 32-bit 'struct comedi_insn *' */
 };
 
 /* Handle translated ioctl. */
-- 
2.1.4

