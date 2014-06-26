Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbaFZRnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 13:43:22 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:18057 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753555AbaFZRnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 13:43:21 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak8KAI5arFNXQz8N/2dsb2JhbABagw2rRQUBAQEBAQEFAW2Yf4ENF3WEYCOBGoh9AcIpF4VkiRwdhC0FmlmTdYNEOw
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: wein@de.ibm.com, stefan.haberland@de.ibm.com,
        Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 0/4] drivers/s390/block/dasd.c: code clean-up
Date: Thu, 26 Jun 2014 19:41:45 +0200
Message-Id: <1403804509-9565-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an untested patchset to address some checkpatch warnings in dasd.c

Fabian Frederick (4):
  drivers/s390/block/dasd.c: remove unnecessary null test before
    debugfs_remove
  drivers/s390/block/dasd.c: Move EXPORT_SYMBOL after function/variable
  drivers/s390/block/dasd.c: replace pr_warning by pr_warn
  drivers/s390/block/dasd.c: replace seq_printf by seq_puts

 drivers/s390/block/dasd.c | 156 +++++++++++++++++++++-------------------------
 1 file changed, 70 insertions(+), 86 deletions(-)

-- 
1.8.4.5

