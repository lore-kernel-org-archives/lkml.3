Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755031AbaCYUjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 16:39:39 -0400
Received: from fieldses.org ([174.143.236.118]:46023 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107AbaCYUjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 16:39:37 -0400
Date: Tue, 25 Mar 2014 16:39:36 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "J. R. Okajima" <hooanon05g@gmail.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: nfsd fix for 3.14
Message-ID: <20140325203936.GA30430@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull an nfsd fix from

  git://linux-nfs.org/~bfields/linux.git nfsd-next

J. R. Okajima sent this early and I was just slow to pass it along,
apologies.  Fortunately it's a simple fix.

--b.

----------------------------------------------------------------
J. R. Okajima (1):
      nfsd: fix lost nfserrno() call in nfsd_setattr()

 fs/nfsd/vfs.c | 1 +
 1 file changed, 1 insertion(+)
