Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934013AbaDIRFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 13:05:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933353AbaDIRFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 13:05:02 -0400
Date: Wed, 9 Apr 2014 19:05:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 0/2] Was: Convert process iteration to use
	for_each_process_thread()
Message-ID: <20140409170505.GA27638@redhat.com>
References: <1397059882-23063-1-git-send-email-fweisbec@gmail.com> <1397059882-23063-3-git-send-email-fweisbec@gmail.com> <360091921.1294.1397060915052.JavaMail.zimbra@efficios.com> <20140409124249.4081e665@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140409124249.4081e665@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09, Steven Rostedt wrote:
>
> The tasklist_lock is all that is needed.

Yes, but not _irq. Plus this code is buggy ;)

Steven, I sent these patches twice (at least!). This time I didn't
bother to recheck this code, but the patches still apply so perhaps
you can take a look?

Last attempt, I promise ;)

Oleg.

