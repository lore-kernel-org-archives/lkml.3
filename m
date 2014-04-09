Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852AbaDISZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 14:25:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51837 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933143AbaDISZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 14:25:57 -0400
Date: Wed, 9 Apr 2014 20:25:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <minggr@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: current->sched_class->yield_task is NULL, any hint?
Message-ID: <20140409182553.GE10526@twins.programming.kicks-ass.net>
References: <CAF1ivSbZKbDc+rzd+CUqCzNmSgZmZTE-QeSU-2WmSiuEs-Kw_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF1ivSbZKbDc+rzd+CUqCzNmSgZmZTE-QeSU-2WmSiuEs-Kw_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 10:43:32AM -0700, Lin Ming wrote:
> Hi Peter,
> 
> I hit a panic in sys_sched_yield() because(for some unknown reason)
> current->sched_class->yield_task is NULL.
> It's an ARM embedded board with 3.4-rt kernel.
> 
> Could you share any hint for the possible causes?

What class does current->sched_class point to?
