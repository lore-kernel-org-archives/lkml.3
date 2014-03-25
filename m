Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaCYTfP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 15:35:15 -0400
Received: from smtprelay0162.hostedemail.com ([216.40.44.162]:56932 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753770AbaCYTfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 15:35:13 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:988:989:1260:1345:1437:1534:1540:1711:1714:1730:1747:1777:1792:1801:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3351:3866:3867:4605:5007:6261:6642:10004:10026:10848:11026:11658:11914:12043:12517:12519:12679:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: month85_10280dc687439
X-Filterd-Recvd-Size: 1642
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org, drbd-user@lists.linbit.com,
        xen-devel@lists.xenproject.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-mm@kvack.org
Subject: [PATCH 0/5] Convert last few uses of __FUNCTION__ to __func__
Date: Tue, 25 Mar 2014 12:35:02 -0700
Message-Id: <cover.1395775901.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Outside of staging, there aren't any more uses of __FUNCTION__ now...

Joe Perches (5):
  powerpc: Convert last uses of __FUNCTION__ to __func__
  x86: Convert last uses of __FUNCTION__ to __func__
  block: Convert last uses of __FUNCTION__ to __func__
  i915: Convert last uses of __FUNCTION__ to __func__
  slab: Convert last uses of __FUNCTION__ to __func__

 arch/powerpc/platforms/pseries/nvram.c       | 11 +++++------
 arch/x86/kernel/hpet.c                       |  2 +-
 arch/x86/kernel/rtc.c                        |  4 ++--
 arch/x86/platform/intel-mid/intel_mid_vrtc.c |  2 +-
 drivers/block/drbd/drbd_int.h                |  8 ++++----
 drivers/block/xen-blkfront.c                 |  4 ++--
 drivers/gpu/drm/i915/dvo_ns2501.c            | 15 ++++++---------
 mm/slab.h                                    |  2 +-
 8 files changed, 22 insertions(+), 26 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

