Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3CKQ2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:28:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:21035 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab3CKQ17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:27:59 -0400
X-IronPort-AV: E=Sophos;i="4.84,824,1355068800"; 
   d="scan'208";a="6852600"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/3] async: simple cleanups
Date: Tue, 12 Mar 2013 00:30:01 +0800
Message-Id: <1363019405-4331-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 00:26:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 00:26:46,
	Serialize complete at 2013/03/12 00:26:46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found somethings need to be cleanup when I watch what has been changed
to async.c.

Lai Jiangshan (3):
  async: simplify lowest_in_progress()
  async: remove unused @node from struct async_domain
  async: rename and redefine async_func_ptr

Cc: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/sh/drivers/pci/pcie-sh7786.c |    2 +-
 include/linux/async.h             |   19 ++++++-----------
 kernel/async.c                    |   40 ++++++++++++++++--------------------
 3 files changed, 26 insertions(+), 35 deletions(-)

-- 
1.7.4.4

