Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbaGTSXw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 14:23:52 -0400
Received: from smtprelay0187.hostedemail.com ([216.40.44.187]:47238 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752463AbaGTSXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 14:23:50 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:69:355:379:541:968:982:988:989:1260:1345:1437:1534:1541:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2731:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:3871:3872:3874:4250:4419:5007:6119:6261:7903:10004:10026:10848:11026:11658:11914:12043:12291:12296:12438:12517:12519:12679:12683:13311:13357:14095:14096:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL
X-HE-Tag: chin59_5b1f4f2485107
X-Filterd-Recvd-Size: 1981
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Teigland <teigland@redhat.com>,
        Jeff Layton <jlayton@poochiereds.net>,
        Christine Caulfield <ccaulfie@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/9] fs.h/dlm: Neatening and argument removals
Date: Sun, 20 Jul 2014 11:23:34 -0700
Message-Id: <cover.1405879494.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs.h is an important file read by many.

Because of its age and the number of people that have modified it,
it's not particularly kernel coding style conformant.

Make it more so.

dlm has an unnecessary always NULL argument passed around.
Remove it along with some other neatenings while adding
function prototype argument descriptions.

Joe Perches (9):
  fs.h: Remove unnecessary extern prototypes
  fs.h: Whitespace neatening
  fs.h: A few more whitespace neatenings
  fs.h: Add argument names to struct file_lock_operations (*funcs)
  fs.h: Add member argument descriptions to lock_manager_operations
  dlm: plock: Add argument descriptions to notiy
  dlm: fs: Remove unused conf from lm_grant
  dlm: plock: Reduce indentation by rearranging order
  fs: dlm: lockd: Convert int result to unsigned char type

 fs/dlm/plock.c     |   34 +-
 fs/lockd/svclock.c |   16 +-
 include/linux/fs.h | 1201 ++++++++++++++++++++++++++--------------------------
 3 files changed, 627 insertions(+), 624 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

