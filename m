Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbaGHI5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:57:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56970 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbaGHI5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:57:50 -0400
From: Mugunthan V N <mugunthanvnm@ti.com>
To: <netdev@vger.kernel.org>
CC: <davem@davemloft.net>, <linux-api@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Mugunthan V N <mugunthanvnm@ti.com>
Subject: [net-next PATCH 0/3] Broadcast/Multicast rate limit via Ethtool Coalesce
Date: Tue, 8 Jul 2014 14:27:38 +0530
Message-ID: <1404809861-7040-1-git-send-email-mugunthanvnm@ti.com>
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
  drivers: net: cpsw: Add support for multicast/boradcast rate limit

 drivers/net/ethernet/ti/cpsw.c | 83 +++++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/ethtool.h   |  4 ++
 2 files changed, 82 insertions(+), 5 deletions(-)

-- 
2.0.0.390.gcb682f8

