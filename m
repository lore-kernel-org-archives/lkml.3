Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbaIURzL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 13:55:11 -0400
Received: from smtprelay0054.hostedemail.com ([216.40.44.54]:56493 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751311AbaIURzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 13:55:10 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:968:973:988:989:1260:1345:1437:1534:1537:1560:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3867:5007:6261:6642:10004:10026:10848:11658:11914:12043:12517:12519:12679:12683:13311:13357:14095:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cat04_fb5853b0bb4e
X-Filterd-Recvd-Size: 1050
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 0/2] powerpc: pci-ioda: Neatening
Date: Sun, 21 Sep 2014 10:55:04 -0700
Message-Id: <cover.1411320262.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk calls should return void

Joe Perches (2):
  powerpc: pci-ioda: Remove unnecessary return value from printk
  powerpc: pci-ioda: Use a single function to emit logging messages

(compiled/untested)

 arch/powerpc/platforms/powernv/pci-ioda.c | 61 +++++++++++++++----------------
 1 file changed, 30 insertions(+), 31 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

