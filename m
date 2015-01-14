Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbbANMq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 07:46:26 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:50643 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbbANMqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 07:46:25 -0500
Date: Wed, 14 Jan 2015 07:46:20 -0500
From: Jeff Layton <jlayton@poochiereds.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linda Walsh <suse@tlinx.org>
Cc: NeilBrown <neilb@suse.de>
Subject: [GIT PULL] please pull file-locking related bugfix for v3.19 (and
 v3.18 stable)
Message-ID: <20150114074620.0f80880b@tlielax.poochiereds.net>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 971780b701946be0d6e34b4abf6eec1ab05ec0c8:

  Merge tag 'gpio-v3.19-3' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio (2015-01-13 15:29:42 +1300)

are available in the git repository at:

  git://git.samba.org/jlayton/linux.git 52d304eb4eaced9ad04b64ba7cd6ceb5153bbf18

for you to fetch changes up to 52d304eb4eaced9ad04b64ba7cd6ceb5153bbf18:

  locks: fix NULL-deref in generic_delete_lease (2015-01-13 07:00:55 -0500)

----------------------------------------------------------------

Just a simple bugfix for a regression that I introduced into v3.18 with
the internal lease API overhaul -- mea culpa. Kudos to Linda and Neil
for tracking this down and fixing it.

----------------------------------------------------------------
NeilBrown (1):
      locks: fix NULL-deref in generic_delete_lease

 fs/locks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
Jeff Layton <jlayton@poochiereds.net>
