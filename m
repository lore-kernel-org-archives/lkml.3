Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921Ab3IDTG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 15:06:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14057 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab3IDTGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 15:06:25 -0400
Date: Wed, 4 Sep 2013 15:06:21 -0400
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: [GIT PULL] dlm updates for 3.12
Message-ID: <20130904190621.GA17844@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull dlm updates from tag:

git://git.kernel.org/pub/scm/linux/kernel/git/teigland/linux-dlm.git dlm-3.12

This set includes a workqueue cleanup and the removal
of incorrect and unneeded signal blocking.

The removal of signal blocking conflicts with Oleg's
201d3df dlm: kill the unnecessary and wrong device_close()->recalc_sigpending()

Let me know if you'd like me to send a resolved patch.
Thanks,
Dave

David Teigland (1):
      dlm: remove signal blocking

Tejun Heo (1):
      dlm: WQ_NON_REENTRANT is meaningless and going away

 fs/dlm/ast.c  |  5 +----
 fs/dlm/user.c | 25 ++++++-------------------
 2 files changed, 7 insertions(+), 23 deletions(-)

