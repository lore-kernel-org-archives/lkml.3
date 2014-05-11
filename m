Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbaEKQM0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 12:12:26 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:37378 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbaEKQMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 12:12:24 -0400
From: Beniamino Galvani <b.galvani@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Beniamino Galvani <b.galvani@gmail.com>
Subject: [PATCH 0/2] arc_emac: promiscuous/multicast mode and netpoll support
Date: Sun, 11 May 2014 18:11:46 +0200
Message-Id: <1399824708-2497-1-git-send-email-b.galvani@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support for promiscuous mode, multicast filtering
and netpoll to the ARC EMAC driver.

They were both tested on a Radxa Rock board which uses a ARC EMAC IP
core integrated in the Rockchip RK3188 SoC.

Beniamino Galvani (2):
  arc_emac: implement promiscuous mode and multicast filtering
  arc_emac: add netpoll support

 drivers/net/ethernet/arc/emac_main.c |   49 ++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

-- 
1.7.10.4

