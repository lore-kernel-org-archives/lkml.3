Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaGKHrE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:47:04 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36137 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbaGKHge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:36:34 -0400
From: varkabhadram@gmail.com
To: netdev@vger.kernel.org
Cc: Thomas.Lendacky@amd.com, geert+renesas@linux-m68k.org,
        ebiederm@xmission.com, macro@linux-mips.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        Varka Bhadram <varkab@cdac.in>
Subject: [PATCH net-next 0/8] cleanup for AMD811E ethernet driver
Date: Fri, 11 Jul 2014 13:05:02 +0530
Message-Id: <1405064110-22579-1-git-send-email-varkabhadram@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram <varkab@cdac.in>

This series cleanup for AMD811E ethernet driver

Varka Bhadram (8):
  ethernet: amd: move amd111e_remove_one after probe
  ethernet: amd: use devm_ioremap()
  ethernet: amd: dynamic debug fixes
  ethernet: amd: fix comment styles
  ethernet: amd: move pci device ids
  ethernet: amd: fix 'foo* bar'
  ethernet: amd: fix spaces and few coding styles
  ethernet: amd: switch case fixes

 drivers/net/ethernet/amd/amd8111e.c |  993 +++++++++++++++++------------------
 1 file changed, 484 insertions(+), 509 deletions(-)

-- 
1.7.9.5

