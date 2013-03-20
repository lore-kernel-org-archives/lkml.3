Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919Ab3CTMIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 08:08:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59701 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3CTMIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 08:08:13 -0400
Message-ID: <1363781277.3724.2.camel@laptop>
Subject: Re: [PATCH 4/8] sched: clean up move_task() and move_one_task()
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 13:07:57 +0100
In-Reply-To: <1363778201.3724.1.camel@laptop>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1360820921-2513-5-git-send-email-iamjoonsoo.kim@lge.com>
	 <1363703415.22553.54.camel@laptop> <20130320073355.GC11672@lge.com>
	 <1363778201.3724.1.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 12:16 +0100, Peter Zijlstra wrote:
> > If your recommandation is to move up can_mirate_task() above
> > load evaluation code, yes, I can, and will do that. :)
> 
> I would actually propose 

... to move the throttled test into can_migrate_task().

(damn evo crashed on me... *again*).

