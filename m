Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbaKNH2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 02:28:14 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:43975 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754339AbaKNH2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 02:28:13 -0500
Date: Fri, 14 Nov 2014 07:28:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [git pull] vfs.git fix
Message-ID: <20141114072811.GM7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Fix for a really embarrassing braino in iov_iter.  Kudos to paulus...
Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Paul Mackerras (1):
      Fix thinko in iov_iter_single_seg_count

Diffstat:
 mm/iov_iter.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
