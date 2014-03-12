Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbaCLNd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:33:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59545 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbaCLNd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:33:26 -0400
Date: Wed, 12 Mar 2014 14:33:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Kirill Tkhai <tkhai@yandex.ru>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH]sched/rt: Do not try to push tasks if pinned task
 switches to RT
Message-ID: <20140312133319.GC27965@twins.programming.kicks-ass.net>
References: <4451359470707@web16g.yandex.ru>
 <20140312061833.3a43aa64@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312061833.3a43aa64@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 06:18:33AM -0400, Steven Rostedt wrote:
> Peter,
> 
> I'm going through my inbox (over a year old), and found this patch from
> Kirill. It looks fine to me. You can apply it with my
> 

Thanks!
