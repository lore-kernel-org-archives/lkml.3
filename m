Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab3D2XI2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 19:08:28 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34483 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757947Ab3D2XI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 19:08:27 -0400
Date: Mon, 29 Apr 2013 16:08:23 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Subject: [GIT PULL] percpu changes for v3.10-rc1
Message-ID: <20130429230823.GH2395@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

A puny pull request for percpu.  We were expecting more cleanup
patches but didn't happen this time, so just a single patch adding
documentation from Christoph.

Thanks.

The following changes since commit 07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.10

for you to fetch changes up to a1b2a555d6375f1ed34d0a1761b540de3a8727c6:

  percpu: add documentation on this_cpu operations (2013-04-04 10:24:53 -0700)

----------------------------------------------------------------
Christoph Lameter (1):
      percpu: add documentation on this_cpu operations

 Documentation/this_cpu_ops.txt | 205 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 205 insertions(+)
 create mode 100644 Documentation/this_cpu_ops.txt

--
tejun
