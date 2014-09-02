Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091AbaIBR7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:59:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbaIBR7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:59:30 -0400
Date: Tue, 2 Sep 2014 19:56:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Suresh Siddha <sbsiddha@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Bean Anderson <bean@azulsystems.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] x86, fpu: misc fixes/cleanups, more to come
Message-ID: <20140902175654.GA21626@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, please consider this series for inclusion.

I added v2 tag to avoid the confusion but the patches are the same,
except the new/offtopic but hopefully trivial 7/7.

2-6 were acked by Suresh (thanks!), the 1st patch still has no acks
although iiuc Linus seems to agree with this change.

Oleg.

 arch/x86/include/asm/fpu-internal.h |    2 +-
 arch/x86/kernel/process.c           |   16 +++++++++-------
 arch/x86/kernel/process_32.c        |    6 +-----
 arch/x86/kernel/process_64.c        |    3 ---
 arch/x86/kernel/signal.c            |    5 +++++
 arch/x86/kernel/xsave.c             |    7 ++++---
 6 files changed, 20 insertions(+), 19 deletions(-)

