Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889Ab3BYEmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 23:42:47 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:34905 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759542Ab3BYEmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 23:42:46 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Rientjes <rientjes@google.com>, axboe <axboe@kernel.dk>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] bug fixes for Linus
Date: Sun, 24 Feb 2013 23:42:35 -0500
Message-Id: <1361767357-8465-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.rc3
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022504-4834-0000-0000-0000040C643A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both of these patches are bug fixes for patches, which were
upstreamed in this open window.  The first patch addresses
a merge issue.  The second patch addresses a CONFIG_BLOCK
dependency.

thanks,

Mimi

Mimi Zohar (2):
  ima: "remove enforce checking duplication" merge fix
  block: fix part_pack_uuid() build error

 include/linux/genhd.h               | 10 ++++++++++
 security/integrity/ima/ima_main.c   |  3 ++-
 security/integrity/ima/ima_policy.c | 11 ++++++-----
 3 files changed, 18 insertions(+), 6 deletions(-)

-- 
1.8.1.rc3

