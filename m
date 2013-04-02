Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab3DBOts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:49:48 -0400
Received: from fieldses.org ([174.143.236.118]:43221 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932378Ab3DBOtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:49:47 -0400
Date: Tue, 2 Apr 2013 10:49:46 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: nfsd bugfix for 3.9
Message-ID: <20130402144946.GC12158@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull another nfsd bugfix from the for-3.9 branch at

  git://linux-nfs.org/~bfields/linux.git for-3.9

(An xdr decoding error--thanks, Toralf Förster, and Trinity!)

--b.

----------------------------------------------------------------
J. Bruce Fields (1):
      nfsd4: reject "negative" acl lengths

 fs/nfsd/nfs4xdr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
