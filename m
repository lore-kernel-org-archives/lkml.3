Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3LFCYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 21:24:24 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54792 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab3LFCYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 21:24:21 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [net-next PATCHv2 0/8] net: some cleanups
Date: Fri,  6 Dec 2013 10:24:01 +0800
Message-Id: <1386296649-6453-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120602-5806-0000-0000-00002399E168
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Since net-next is open now, it's time to post them out again.

Zhi Yong Wu (8):
  vhost: remove the dead branch
  vhost: adjust vhost_dev_init() to be void
  macvtap: remove the dead branch
  macvtap: adjust macvtap_skb_to_vnet_hdr() to be void
  macvtap: update file current position
  macvtap: remove unused parameter in macvtap_do_read()
  tun: update file current position
  tun: remove unused parameter in tun_do_read()

 drivers/net/macvtap.c |   16 +++++++---------
 drivers/net/tun.c     |    9 +++++----
 drivers/vhost/net.c   |    9 ++-------
 drivers/vhost/scsi.c  |    7 +------
 drivers/vhost/test.c  |    8 +-------
 drivers/vhost/vhost.c |    4 +---
 drivers/vhost/vhost.h |    2 +-
 7 files changed, 18 insertions(+), 37 deletions(-)

-- 
1.7.6.5

