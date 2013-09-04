Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761973Ab3IDFrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 01:47:35 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:35776 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab3IDFre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 01:47:34 -0400
From: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
To: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: benve@cisco.com, ssujith@cisco.com, nistrive@cisco.com, umalhi@cisco.com,
        Govindarajulu Varadarajan <govindarajulu90@gmail.com>
Subject: [PATCH net-next 0/5] driver/net: enic: enic driver updates
Date: Wed,  4 Sep 2013 11:17:13 +0530
Message-Id: <1378273638-7780-1-git-send-email-govindarajulu90@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series includes support for multi-tx, rss_hash, RPS, RFS, DMA64, 
export symbols for cisco low latency driver and update the driver version and 
driver maintainers.

Govindarajulu Varadarajan (5):
  driver/net: enic: Add multi tx support for enic
  driver/net: enic: record q_number and rss_hash for skb
  driver/net: enic: Try DMA 64 first, then failover to DMA
  driver/net: enic: Exposing symbols for Cisco's low latency driver
  driver/net: enic: update enic maintainers and driver

 MAINTAINERS                                 |  3 +-
 drivers/net/ethernet/cisco/enic/enic.h      |  4 +--
 drivers/net/ethernet/cisco/enic/enic_main.c | 55 ++++++++++++++++++++---------
 drivers/net/ethernet/cisco/enic/vnic_dev.c  | 10 ++++++
 drivers/net/ethernet/cisco/enic/vnic_dev.h  |  1 +
 5 files changed, 54 insertions(+), 19 deletions(-)

-- 
1.8.4

