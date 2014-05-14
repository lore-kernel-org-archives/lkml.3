Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaENTPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:15:21 -0400
Received: from smtprelay0107.hostedemail.com ([216.40.44.107]:37766 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750834AbaENTPT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:15:19 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:968:973:988:989:1260:1345:1437:1537:1560:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3876:3877:4605:5007:6114:6261:6312:6642:10004:10026:10848:11658:11914:12043:12517:12519:12679:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: spy62_856c98c8bf553
X-Filterd-Recvd-Size: 945
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] drivers/net: Remove trailing semicolons from do {...} while 0 macros
Date: Wed, 14 May 2014 12:15:12 -0700
Message-Id: <cover.1400094804.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (2):
  ti: Remove trailing semicolon from do {...} while (0) macro
  wlcore: Remove trailing semicolon from do {...} while (0) macro

 drivers/net/ethernet/ti/cpsw.c           | 4 ++--
 drivers/net/wireless/ti/wlcore/debugfs.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

