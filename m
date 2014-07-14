Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbaGNIlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:41:05 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55237 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaGNIlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:41:00 -0400
From: varkabhadram@gmail.com
To: netdev@vger.kernel.org
Cc: Thomas.Lendacky@amd.com, geert+renesas@linux-m68k.org,
        ebiederm@xmission.com, macro@linux-mips.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        Varka Bhadram <varkab@cdac.in>
Subject: [PATCH net-next v3 0/6] cleanup for AMD8111E ethernet driver
Date: Mon, 14 Jul 2014 14:09:03 +0530
Message-Id: <1405327149-6554-1-git-send-email-varkabhadram@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram <varkab@cdac.in>

This series cleanup for AMD8111E ethernet driver

v1: fix checkpatch warnings.
v2: added new line in debug messages

Varka Bhadram (6):
  ethernet: amd: move amd111e_remove_one after probe
  ethernet: amd: use devm_ioremap()
  ethernet: amd: dynamic debug fixes
  ethernet: amd: fix comment styles
  ethernet: amd: fix pci device ids
  ethernet: amd: fix 'foo* bar'

 drivers/net/ethernet/amd/amd8111e.c |  363 +++++++++++++++++------------------
 1 file changed, 176 insertions(+), 187 deletions(-)

-- 
1.7.9.5

