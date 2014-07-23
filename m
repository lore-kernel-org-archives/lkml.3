Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185AbaGWSjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 14:39:46 -0400
Received: from fieldses.org ([174.143.236.118]:47714 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933011AbaGWSjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 14:39:45 -0400
Date: Wed, 23 Jul 2014 14:39:44 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Subject: 3.16 nfsd bugfix
Message-ID: <20140723183944.GE9118@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull one more 3.16 bugfix from

  git://linux-nfs.org/~bfields/linux.git for-3.16

Another regression from the xdr encoding rewrite.

--b.

----------------------------------------------------------------
Kinglong Mee (1):
      NFSD: Fix crash encoding lock reply on 32-bit

 fs/nfsd/nfs4xdr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
