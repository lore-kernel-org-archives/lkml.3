Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab3LFUNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:13:18 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45508 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab3LFUNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:13:17 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [PATCH v4 net-next 0/4] net: some cleanups
Date: Sat,  7 Dec 2013 04:13:02 +0800
Message-Id: <1386360786-17687-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120620-5806-0000-0000-0000239B7432
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Since net-next is open now, it's time to post them out again.

Changelog from v3:
 -combine the change that removes the return value check with
the change which adjusts the function return type to "void". [David Miller]

Zhi Yong Wu (4):
  vhost: remove the dead branch
  macvtap: remove the dead branch
  macvtap: remove unused parameter in macvtap_do_read()
  tun: remove unused parameter in tun_do_read()

 drivers/net/macvtap.c |   14 +++++---------
 drivers/net/tun.c     |    7 +++----
 drivers/vhost/net.c   |    9 ++-------
 drivers/vhost/scsi.c  |    7 +------
 drivers/vhost/test.c  |    8 +-------
 drivers/vhost/vhost.c |    4 +---
 drivers/vhost/vhost.h |    2 +-
 7 files changed, 14 insertions(+), 37 deletions(-)

-- 
1.7.6.5

