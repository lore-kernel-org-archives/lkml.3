Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642Ab3CKTph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:45:37 -0400
Received: from fieldses.org ([174.143.236.118]:46755 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab3CKTpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:45:35 -0400
Date: Mon, 11 Mar 2013 15:45:30 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: 3.9 nfsd bugfixes
Message-ID: <20130311194530.GC642@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull a couple 3.9 nfsd bugfixes from:

  git://linux-nfs.org/~bfields/linux.git for-3.9

Some minor fallout from the user-namespace work broke most krb5 mounts
to nfsd, and I screwed up a change to the AF_LOCAL rpc code.

--b.

----------------------------------------------------------------
J. Bruce Fields (2):
      nfsd: fix krb5 handling of anonymous principals
      sunrpc: don't attempt to cancel unitialized work

 net/sunrpc/auth_gss/svcauth_gss.c |   12 ++++++++----
 net/sunrpc/xprtsock.c             |   15 ++++++++++-----
 2 files changed, 18 insertions(+), 9 deletions(-)
