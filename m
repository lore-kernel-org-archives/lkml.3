Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab3ICOe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:34:59 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:37494 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab3ICOe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:34:58 -0400
Date: Tue, 3 Sep 2013 10:34:54 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] workqueue changes for v3.12-rc1
Message-ID: <20130903143454.GG10522@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Nothing interesting.  All are doc / comment updates.

Thanks.

The following changes since commit ad81f0545ef01ea651886dddac4bef6cec930092:

  Linux 3.11-rc1 (2013-07-14 15:18:27 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.12

for you to fetch changes up to 546d30c4a2e61a53d408e5f40d01278f144bb0f5:

  workqueue: Correct/Drop references to gcwq in Documentation (2013-08-21 10:32:09 -0400)

----------------------------------------------------------------
Libin (3):
      workqueue: Comment correction in file header
      workqueue: Fix manage_workers() RETURNS description
      workqueue: Correct/Drop references to gcwq in Documentation

Tejun Heo (1):
      workqueue: mark WQ_NON_REENTRANT deprecated

 Documentation/workqueue.txt | 90 +++++++++++++++++++++------------------------
 include/linux/workqueue.h   |  7 +++-
 kernel/workqueue.c          | 14 ++++---
 3 files changed, 57 insertions(+), 54 deletions(-)

--
tejun
