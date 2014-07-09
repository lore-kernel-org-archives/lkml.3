Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbaGIHOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 03:14:22 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36444 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaGIHOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 03:14:20 -0400
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <linux-api@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mugunthan V N <mugunthanvnm@ti.com>
Subject: [net-next PATCH v2 0/3] Broadcast/Multicast rate limit via Ethtool Coalesce
Date: Wed, 9 Jul 2014 12:44:07 +0530
Message-ID: <1404890050-4020-1-git-send-email-mugunthanvnm@ti.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A system/cpu can be loaded by a hacker with flooding of broadcast or
multicast packets, to prevent this some Ethernet controllers like CPSW
provide a mechanism to limit the broadcast/multicast packet rate via
hardware limiters. This patch series enables this feature via
Ethtool Coalesce.

Mugunthan V N (3):
  net: ethtool: Add Multicast and broadcast rate limit coalescing
    feature
  drivers: net: cpsw: remove redundancy check
  drivers: net: cpsw: Add support for multicast/broadcast rate limit

 drivers/net/ethernet/ti/cpsw.c | 83 +++++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/ethtool.h   |  4 ++
 2 files changed, 82 insertions(+), 5 deletions(-)

-- 
2.0.0.390.gcb682f8

