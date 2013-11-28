Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440Ab3K1Bbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 20:31:44 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:47332 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3K1Bbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 20:31:42 -0500
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RESEND PATCH net-next 0/4] net: several cleanups
Date: Thu, 28 Nov 2013 09:31:29 +0800
Message-Id: <1385602293-24024-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112801-0928-0000-0000-0000041BD0DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

Per David's request, it's time to resend them now.

Zhi Yong Wu (4):
  vhost: remove the dead branch
  vhost: adjust vhost_dev_init() to be void
  macvtap: remove the dead branch
  macvtap: adjust macvtap_skb_to_vnet_hdr() to be void

 drivers/net/macvtap.c |    8 ++------
 drivers/vhost/net.c   |    9 ++-------
 drivers/vhost/scsi.c  |    7 +------
 drivers/vhost/test.c  |    8 +-------
 drivers/vhost/vhost.c |    4 +---
 drivers/vhost/vhost.h |    2 +-
 6 files changed, 8 insertions(+), 30 deletions(-)

-- 
1.7.6.5

