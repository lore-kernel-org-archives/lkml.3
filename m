Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751006Ab3BYFTH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 00:19:07 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:55256 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3BYFTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 00:19:06 -0500
Subject: [PATCH  RESEND 0/3] e1000e: return runtime-pm back to work
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Mon, 25 Feb 2013 09:18:59 +0400
Message-ID: <20130225051010.12689.28611.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

here some fixes for e1000e driver from:
https://lkml.org/lkml/2013/2/4/185
The rest patches from that patchset already committed.

---

Konstantin Khlebnikov (3):
      e1000e: fix pci-device enable-counter balance
      e1000e: fix runtime power management transitions
      e1000e: fix accessing to suspended device


 drivers/net/ethernet/intel/e1000e/ethtool.c |   13 ++++
 drivers/net/ethernet/intel/e1000e/netdev.c  |   82 +++++++--------------------
 2 files changed, 34 insertions(+), 61 deletions(-)

-- 
Signature
