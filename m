Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab3CRT1j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:27:39 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44123 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3CRT1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:27:38 -0400
Date: Mon, 18 Mar 2013 12:27:34 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [GIT PULL] workqueue fixes changes for 3.9-rc3
Message-ID: <20130318192734.GE3042@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Please pull from the following branch to receive Lai's patch to fix
highly unlikely but still possible workqueue stall during CPU
hotunplug.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.9-fixes

Thanks.

----------------------------------------------------------------
Lai Jiangshan (1):
      workqueue: fix possible pool stall bug in wq_unbind_fn()

 kernel/workqueue.c | 44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

--
tejun
