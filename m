Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbaDNRlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:41:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51973 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbaDNRle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:41:34 -0400
Message-ID: <534C1DC9.7020108@infradead.org>
Date: Mon, 14 Apr 2014 10:41:29 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Sebastian Ott <sebott@linux.vnet.ibm.com>,
        Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        linux-s390@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com
Subject: [PATCH] s390: fix new ccwgroup.h kernel-doc warning
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix new s390 kernel-doc warning:

Warning(arch/s390/include/asm/ccwgroup.h:27): No description found for parameter 'ungroup_work'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc:	Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc:	linux-s390@vger.kernel.org
Cc:	Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc:	Heiko Carstens <heiko.carstens@de.ibm.com>
Cc:	linux390@de.ibm.com
---
 arch/s390/include/asm/ccwgroup.h |    2 ++
 1 file changed, 2 insertions(+)

--- lnx-315-rc1.orig/arch/s390/include/asm/ccwgroup.h
+++ lnx-315-rc1/arch/s390/include/asm/ccwgroup.h
@@ -10,6 +10,8 @@ struct ccw_driver;
  * @count: number of attached slave devices
  * @dev: embedded device structure
  * @cdev: variable number of slave devices, allocated as needed
+ * @ungroup_work: work to be done when a ccwgroup notifier has action
+ *	type %BUS_NOTIFY_UNBIND_DRIVER
  */
 struct ccwgroup_device {
 	enum {
