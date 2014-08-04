Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaHDNBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:01:11 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.102]:58048 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaHDNBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:01:10 -0400
X-Greylist: delayed 340 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Aug 2014 09:01:10 EDT
From: Christoph Jaeger <email@christophjaeger.info>
To: shigekatsu.tateno@atmel.com, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Christoph Jaeger <email@christophjaeger.info>
Subject: [PATCH 00/10] staging: Clean up ozwpan driver
Date: Mon,  4 Aug 2014 14:54:46 +0200
Message-Id: <1407156896-3246-1-git-send-email-email@christophjaeger.info>
X-Mailer: git-send-email 1.9.3
X-Df-Sender: MTg4NDM4Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set does some cleanup; no functional change.

Christoph Jaeger (10):
  staging: ozwpan: Add module parameter description
  staging: ozwpan: Fix typo in typedef
  staging: ozwpan: Remove unused OZ_MAX_TIMER_POOL_SIZE
  staging: ozwpan: Remove redundant initialization
  staging: ozwpan: Remove dead code
  staging: ozwpan: Simplify app interface
  staging: ozwpan: Use slab cache for oz_urb_link allocation
  staging: ozwpan: Use slab cache for oz_elt_info allocation
  staging: ozwpan: Use slab cache for oz_tx_frame allocation
  staging: ozwpan: Use list helpers

 drivers/staging/ozwpan/ozcdev.c     |  31 ++--
 drivers/staging/ozwpan/ozeltbuf.c   | 131 +++------------
 drivers/staging/ozwpan/ozeltbuf.h   |   7 +-
 drivers/staging/ozwpan/ozhcd.c      | 166 +++++--------------
 drivers/staging/ozwpan/ozmain.c     |   4 +-
 drivers/staging/ozwpan/ozpd.c       | 307 ++++++++++--------------------------
 drivers/staging/ozwpan/ozpd.h       |   9 +-
 drivers/staging/ozwpan/ozproto.c    |  36 +++--
 drivers/staging/ozwpan/ozproto.h    |   8 +-
 drivers/staging/ozwpan/ozprotocol.h |   2 -
 drivers/staging/ozwpan/ozusbsvc.c   |  30 ++--
 drivers/staging/ozwpan/ozusbsvc1.c  |  12 +-
 12 files changed, 223 insertions(+), 520 deletions(-)

-- 
1.9.1

