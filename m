Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaIHBG5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 21:06:57 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46539 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbaIHBG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 21:06:56 -0400
Date: Mon, 8 Sep 2014 10:06:51 +0900
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Subject: [GIT PULL] percpu fixes for v3.17-rc4
Message-ID: <20140908010651.GE5061@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

One patch to fix a failure path in the alloc path.  The bug is
dangerous but probably not too likely to actually trigger in the wild
given that there hasn't been any report yet.  The other two are low
impact fixes.

Thanks.

The following changes since commit c9d26423e56ce1ab4d786f92aebecf859d419293:

  Merge tag 'pm+acpi-3.17-rc1-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm (2014-08-14 18:13:46 -0600)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.17-fixes

for you to fetch changes up to 3189eddbcafcc4d827f7f19facbeddec4424eba8:

  percpu: free percpu allocation info for uniprocessor system (2014-08-16 08:59:02 -0400)

----------------------------------------------------------------
Honggang Li (1):
      percpu: free percpu allocation info for uniprocessor system

Tejun Heo (2):
      percpu: fix pcpu_alloc_pages() failure path
      percpu: perform tlb flush after pcpu_map_pages() failure

 mm/percpu-vm.c | 22 ++++++++++++++++------
 mm/percpu.c    |  2 ++
 2 files changed, 18 insertions(+), 6 deletions(-)

-- 
tejun
