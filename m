Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbaEIOyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 10:54:21 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:45270 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbaEIOyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 10:54:19 -0400
Message-ID: <536CEAEE.4010609@gmail.com>
Date: Fri, 09 May 2014 16:49:18 +0200
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mtk.manpages@gmail.com, lkml <linux-kernel@vger.kernel.org>,
        Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 0/3] sched: sched_setattr/sched_getattr fixes and improvements
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

While looking at your sched_setattr()/sched_getatr() documentation, 
I noticed a bug in the handling of -EFBIG, and a couple of places 
in the code where the error handling logic could be streamlined.
Patches follow.

Cheers,

Michael
-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
