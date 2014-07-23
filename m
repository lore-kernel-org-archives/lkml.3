Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbaGWDvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 23:51:19 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:59277 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbaGWDvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 23:51:18 -0400
From: varkabhadram@gmail.com
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
        Varka Bhadram <varkab@cdac.in>
Subject: [PATCH net-next v3 0/2] cleanup for Realtek 8139CP
Date: Wed, 23 Jul 2014 09:19:47 +0530
Message-Id: <1406087389-4436-1-git-send-email-varkabhadram@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram <varkab@cdac.in>

changes since v2:
        - making version info print once.
changes sice v1:
        - remove unused varible warning

Varka Bhadram (2):
  ethernet: realtek: use module_pci_driver
  ethernet: realtek: use pci_device_id

 drivers/net/ethernet/realtek/8139cp.c |   36 +++++++++------------------------
 1 file changed, 9 insertions(+), 27 deletions(-)

-- 
1.7.9.5

