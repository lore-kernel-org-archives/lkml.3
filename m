Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172AbaDNWJb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:09:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52339 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408AbaDNWJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:09:21 -0400
Date: Mon, 14 Apr 2014 15:09:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Richard Weinberger <richard@nod.at>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 07/11] signals: jffs2: fix the wrong usage of
 disallow_signal()
Message-Id: <20140414150920.6202c16be770f7ab8d79e96f@linux-foundation.org>
In-Reply-To: <20140414152010.GA22012@redhat.com>
References: <20140414151929.GA21470@redhat.com>
	<20140414152010.GA22012@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hm, 6, 7, 8 and 9 hit my inbox via the you->me route but I didn't get
the second copy of those 4 via the vger->me route.  And several in
the series remain lost

https://lkml.org/lkml/2014/4/14/ received 4,5,6,7,8,9,10,11 but seems
to be missing 0,1,2,3.

Something is screwed up somewhere.

