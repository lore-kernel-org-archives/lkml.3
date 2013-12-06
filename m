Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab3LFGTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 01:19:55 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55345 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974Ab3LFGTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 01:19:53 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [net-next PATCH v3 0/6] net: some cleanups
Date: Fri,  6 Dec 2013 14:19:36 +0800
Message-Id: <1386310782-9378-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120606-5806-0000-0000-0000239A170A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Since net-next is open now, it's time to post them again.

Zhi Yong Wu (6):
  vhost: remove the dead branch
  vhost: adjust vhost_dev_init() to be void
  macvtap: remove the dead branch
  macvtap: adjust macvtap_skb_to_vnet_hdr() to be void
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

