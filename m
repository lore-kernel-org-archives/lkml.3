Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab3LXOX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 09:23:57 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:50639 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab3LXOX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 09:23:56 -0500
Date: Tue, 24 Dec 2013 09:23:52 -0500
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] percpu fixes for v3.13-rc5
Message-ID: <20131224142352.GB3512@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

A single commit to fix a spurious sparse warning coming from
DEFINE_PER_CPU()'s hack to support the use of weak symbols.  Shouldn't
cause observable behavior change.

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.13-fixes

for you to fetch changes up to b1a0fbfdde65dffd83c84c006f84fa12041907c5:

  percpu: fix spurious sparse warnings from DEFINE_PER_CPU() (2013-12-05 12:59:23 -0500)

Thanks.

----------------------------------------------------------------
Tejun Heo (1):
      percpu: fix spurious sparse warnings from DEFINE_PER_CPU()

 include/linux/percpu-defs.h | 1 +
 1 file changed, 1 insertion(+)

-- 
tejun
