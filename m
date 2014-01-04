Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176AbaADAIy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 19:08:54 -0500
Received: from smtprelay0088.hostedemail.com ([216.40.44.88]:54093 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753834AbaADAIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 19:08:53 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:988:989:1260:1345:1537:1559:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3876:3877:5007:6114:6261:6312:6642:10004:10026:10848:11658:11914:12043:12291:12517:12519:12679:12683:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: work45_130e82223f741
X-Filterd-Recvd-Size: 810
From: Joe Perches <joe@perches.com>
To: Matt Fleming <matt.fleming@intel.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] efi: Fix krealloc defect and misc neatening
Date: Fri,  3 Jan 2014 16:08:46 -0800
Message-Id: <cover.1388793978.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (2):
  efi: Fix krealloc defect
  efi: style neatening

 arch/x86/platform/efi/efi.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

