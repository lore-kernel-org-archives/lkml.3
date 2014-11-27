Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaK0XEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:04:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbaK0XEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:04:05 -0500
Date: Fri, 28 Nov 2014 00:03:49 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] oom && coredump
Message-ID: <20141127230349.GA25075@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27, Oleg Nesterov wrote:
>
> So I think the patch below makes sense anyway. Although I should probably
> split it and remove PT_TRACE_EXIT in 2/2.

So let me send the patches.

David, Michal, could you review and ack/nack these changes explicitly?

Let me repeat once again that this patch doesn't pretend to solve
all problems, even with the coredumping. And I have to admit that
my main motivation is 2/2, this PT_TRACE_EXIT check annoys me ;)

Oleg.

 mm/oom_kill.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

