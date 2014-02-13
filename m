Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaBMT7y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:59:54 -0500
Received: from fieldses.org ([174.143.236.118]:40153 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbaBMT7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:59:52 -0500
Date: Thu, 13 Feb 2014 14:59:51 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] nfsd bugfixes for 3.14
Message-ID: <20140213195951.GA21982@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull two nfsd bugfixes for 3.14:

  git://linux-nfs.org/~bfields/linux.git for-3.14

--b.

----------------------------------------------------------------
J. Bruce Fields (1):
      nfsd4: fix acl buffer overrun

NeilBrown (1):
      lockd: send correct lock when granting a delayed lock.

 fs/lockd/svclock.c |    8 ++++++++
 fs/nfsd/nfs4acl.c  |    9 +++------
 2 files changed, 11 insertions(+), 6 deletions(-)
