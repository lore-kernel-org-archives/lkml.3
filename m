Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759650AbaGCWIG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:08:06 -0400
Received: from smtprelay0140.hostedemail.com ([216.40.44.140]:33593 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752673AbaGCWIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:08:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:69:355:379:541:968:973:988:989:1260:1345:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:2895:3138:3139:3140:3141:3142:3352:3865:3866:3868:4250:5007:6117:6119:6261:7809:7903:7974:8784:10004:10026:10848:11658:11914:12043:12517:12519:12679:12683:13311:13357:14095:14096:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: front63_291d2465e9046
X-Filterd-Recvd-Size: 1562
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 00/16] MAINTAINERS: Update patterns
Date: Thu,  3 Jul 2014 15:07:44 -0700
Message-Id: <cover.1404425176.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Semi-random periodic cleaning of incorrect patterns.

Joe Perches (16):
  MAINTAINERS: Update microcode patterns
  MAINTAINERS: Update cifs location
  MAINTAINERS: Use the correct efi-stub location
  MAINTAINERS: Update clk/sirf patterns
  MAINTAINERS: Fix ssbi pattern
  MAINTAINERS: Use correct filename for sdhci-bcm-kona
  MAINTAINERS: Fix PXA3xx NAND FLASH DRIVER pattern
  MAINTAINERS: Update picoxcell patterns
  MAINTAINERS: Update Samsunt MFD drivers pattern
  MAINTAINERS: Update staging removals and movements
  MAINTAINERS: Remove section CIRRUS LOGIC EP93XX OHCI USB HOST DRIVER
  MAINTAINERS: Remove METAG imgdafs pattern
  MAINTAINERS: Remove unused radeon drm pattern
  MAINTAINERS: Remove unusd ARM/QUALCOMM MSM pattern
  MAINTAINERS: Remove unused NFSD pattern
  MAINTAINERS: Update rcu torture patterns

 MAINTAINERS | 60 +++++++++++++-----------------------------------------------
 1 file changed, 13 insertions(+), 47 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

