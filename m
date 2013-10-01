Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab3JARRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 13:17:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34806 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab3JARRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:17:06 -0400
Date: Tue, 1 Oct 2013 18:17:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Glauber Costa <glommer@openvz.org>, Dave Chinner <dchinner@redhat.com>
Subject: [git pull] fix lru_list leaks
Message-ID: <20131001171702.GX13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fix in "super: fix for destroy lrus" didn't - they need to be
destroyed, all right, but that's the wrong place...  Please, pull
from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (1):
      fs/super.c: fix lru_list leak for real

Diffstat:
 fs/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
