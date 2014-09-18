Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbaIRUaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 16:30:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757207AbaIRUac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 16:30:32 -0400
Date: Thu, 18 Sep 2014 22:27:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Aaron Tomlin <atomlin@redhat.com>
Cc: peterz@infradead.org, mingo@redhat.com, dzickus@redhat.com, bmr@redhat.com,
        jcastillo@redhat.com, riel@redhat.com, prarit@redhat.com,
        jgh@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        x86@kernel.org, rostedt@goodmis.org, hannes@cmpxchg.org,
        aneesh.kumar@linux.vnet.ibm.com, akpm@linux-foundation.org,
        akpm@google.com, linuxppc-dev@lists.ozlabs.org, minchan@kernel.org,
        mpe@ellerman.id.au
Subject: Re: [PATCH v4 1/3] init/main.c: Give init_task a canary
Message-ID: <20140918202701.GA10695@redhat.com>
References: <1410527779-8133-1-git-send-email-atomlin@redhat.com> <1410527779-8133-2-git-send-email-atomlin@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410527779-8133-2-git-send-email-atomlin@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12, Aaron Tomlin wrote:
>
> Tasks get their end of stack set to STACK_END_MAGIC with the
> aim to catch stack overruns. Currently this feature does not
> apply to init_task. This patch removes this restriction.
>
> Note that a similar patch was posted by Prarit Bhargava [1]
> some time ago but was never merged.
>
> [1]: http://marc.info/?l=linux-kernel&m=127144305403241&w=2
>
> Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
> Acked-by: Michael Ellerman <mpe@ellerman.id.au>

Acked-by: Oleg Nesterov <oleg@redhat.com>

