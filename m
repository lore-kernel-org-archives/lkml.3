Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbaIJOtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:49:35 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:58686 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaIJOtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:49:33 -0400
From: Rob Jones <rob.jones@codethink.co.uk>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, dan.carpenter@oracle.com,
        akpm@linux-foundation.org, jlbec@evilplan.org, mfasheh@suse.com,
        linux-kernel@codethink.co.uk, rob.jones@codethink.co.uk
Subject: [PATCH 0/3] fs: ocfs2: use seq_open_private()
Date: Wed, 10 Sep 2014 15:49:15 +0100
Message-Id: <1410360558-28399-1-git-send-email-rob.jones@codethink.co.uk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use seq_open_private() and __seq_open_private() to reduce boilerplate
code in ocfs2.

These two functions have been around, undocumented, for years. They can
simplify the set up code for seq file operations.

Note that sparse complains about all three files in this series but the
problems are outside the remit of this patch series.

Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>

Rob Jones (3):
  fs: ocfs2: use seq_open_private() not seq_open()
  fs: ocfs2: use seq_open_private() not seq_open()
  fs: ocfs2: Use __seq_open_private() not seq_open()

 fs/ocfs2/cluster/netdebug.c |   78 +++++++++++--------------------------------
 fs/ocfs2/dlm/dlmdebug.c     |   39 ++++++++--------------
 fs/ocfs2/dlmglue.c          |   23 +++----------
 3 files changed, 38 insertions(+), 102 deletions(-)

-- 
1.7.10.4

