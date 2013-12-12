Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab3LLTQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 14:16:23 -0500
Received: from fieldses.org ([174.143.236.118]:44781 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab3LLTQV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 14:16:21 -0500
Date: Thu, 12 Dec 2013 14:16:21 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] nfsd reply cache bugfix
Message-ID: <20131212191621.GA13467@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull one bugfix for nfsd crashes from

  git://linux-nfs.org/~bfields/linux.git for-3.13

--b.

----------------------------------------------------------------
Jeff Layton (1):
      nfsd: when reusing an existing repcache entry, unhash it first

 fs/nfsd/nfscache.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)
