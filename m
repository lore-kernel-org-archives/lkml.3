Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaF2AUX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 20:20:23 -0400
Received: from smtprelay0196.hostedemail.com ([216.40.44.196]:37958 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751197AbaF2AUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 20:20:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:968:988:989:1260:1345:1437:1534:1538:1561:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3868:4605:5007:6261:10004:10026:10848:11026:11473:11658:11914:12043:12291:12438:12517:12519:12679:12683:13311:13357:14095:14110:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dime16_1fd579adc7901
X-Filterd-Recvd-Size: 1094
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/4] fs.h: Kernel style updates
Date: Sat, 28 Jun 2014 17:20:12 -0700
Message-Id: <cover.1403999769.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly s/s/w/hitespace cleaning.

Joe Perches (4):
  fs.h: Remove unnecessary extern prototypes
  fs.h: Whitespace neatening
  fs.h: A few more whitespace neatenings
  fs: asus_atk0110: Fix DEFINE_SIMPLE_ATTRIBUTE semicolon definition and use

 drivers/hwmon/asus_atk0110.c |    2 +-
 include/linux/fs.h           | 1185 +++++++++++++++++++++---------------------
 2 files changed, 598 insertions(+), 589 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

