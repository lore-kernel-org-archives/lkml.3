Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377AbaIENqA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:46:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbaIENp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:45:59 -0400
Date: Fri, 5 Sep 2014 15:43:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Suresh Siddha <sbsiddha@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] x86, fpu: kernel_fpu_begin/end fixes/cleanups
Message-ID: <20140905134325.GA14228@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Suresh, please review when you have time. FYI, I will be travelling
till Sep 10 and I won't be able to reply.

Not for inclusion yet, just for review.

v2:

	1-3: No changes except the minor updates in the changelogs
	     and comments

	4-5: New. 5/5 is purely cosmetic.

Oleg.

 arch/x86/include/asm/fpu-internal.h |   15 ++++++++---
 arch/x86/include/asm/i387.h         |    6 ++++-
 arch/x86/kernel/i387.c              |   45 +++++++++++++++++++++-------------
 arch/x86/kernel/traps.c             |   16 ++++-------
 4 files changed, 50 insertions(+), 32 deletions(-)

