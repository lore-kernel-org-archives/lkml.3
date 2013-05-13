Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab3EMQnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 12:43:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:54185 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3EMQng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 12:43:36 -0400
Message-ID: <519117A4.3020807@infradead.org>
Date: Mon, 13 May 2013 09:41:08 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        eric paris <eparis@redhat.com>, linux-audit@redhat.com
Subject: [PATCH] auditfilter.c: fix kernel-doc warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix kernel-doc warnings in kernel/auditfilter.c:

Warning(kernel/auditfilter.c:1029): Excess function parameter 'loginuid' description in 'audit_receive_filter'
Warning(kernel/auditfilter.c:1029): Excess function parameter 'sessionid' description in 'audit_receive_filter'
Warning(kernel/auditfilter.c:1029): Excess function parameter 'sid' description in 'audit_receive_filter'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 kernel/auditfilter.c |    3 ---
 1 file changed, 3 deletions(-)

--- lnx-310-rc1.orig/kernel/auditfilter.c
+++ lnx-310-rc1/kernel/auditfilter.c
@@ -1021,9 +1021,6 @@ static void audit_log_rule_change(char *
  * @seq: netlink audit message sequence (serial) number
  * @data: payload data
  * @datasz: size of payload data
- * @loginuid: loginuid of sender
- * @sessionid: sessionid for netlink audit message
- * @sid: SE Linux Security ID of sender
  */
 int audit_receive_filter(int type, int pid, int seq, void *data, size_t datasz)
 {
