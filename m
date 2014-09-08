Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaIHRHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 13:07:34 -0400
Received: from fieldses.org ([174.143.236.118]:60329 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753826AbaIHRHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 13:07:33 -0400
Date: Mon, 8 Sep 2014 13:07:32 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: nfsd bugfixes for 3.17
Message-ID: <20140908170732.GA1776@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull a couple minor nfsd bugfixes from:

  git://linux-nfs.org/~bfields/linux.git for-3.17

--b.

----------------------------------------------------------------
J. Bruce Fields (2):
      nfsd4: fix rd_dircount enforcement
      lockd: fix rpcbind crash on lockd startup failure

 fs/lockd/svc.c    |  4 +---
 fs/nfsd/nfs4xdr.c | 14 +++++++++++++-
 2 files changed, 14 insertions(+), 4 deletions(-)
