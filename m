Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaCFUK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:10:56 -0500
Received: from smtprelay0198.hostedemail.com ([216.40.44.198]:33885 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752588AbaCFUKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:10:54 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:960:988:989:1260:1345:1359:1534:1539:1568:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3867:4605:5007:6261:6642:10004:10026:10848:11658:11914:12043:12291:12296:12517:12519:12683:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: form25_5ef0648384525
X-Filterd-Recvd-Size: 1511
From: Joe Perches <joe@perches.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, cluster-devel@redhat.com
Subject: [PATCH 0/3] gfs: More logging neatening
Date: Thu,  6 Mar 2014 12:10:44 -0800
Message-Id: <cover.1394136338.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <20140306182724.6754407d4c629085d9fc318e@skynet.be>
References: <20140306182724.6754407d4c629085d9fc318e@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (3):
  gfs2: Use pr_<level> more consistently
  gfs2: Use fs_<level> more often
  gfs2: Convert gfs2_lm_withdraw to use fs_err

 fs/gfs2/dir.c        | 14 ++++----
 fs/gfs2/glock.c      |  8 +++--
 fs/gfs2/lock_dlm.c   |  9 +++--
 fs/gfs2/main.c       |  2 ++
 fs/gfs2/ops_fstype.c | 25 ++++++-------
 fs/gfs2/quota.c      | 10 +++---
 fs/gfs2/rgrp.c       | 24 +++++++------
 fs/gfs2/super.c      | 16 ++++-----
 fs/gfs2/sys.c        |  6 ++--
 fs/gfs2/trans.c      | 19 +++++-----
 fs/gfs2/util.c       | 99 +++++++++++++++++++++++++---------------------------
 fs/gfs2/util.h       | 31 ++++++++--------
 12 files changed, 138 insertions(+), 125 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

