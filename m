Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab3AXLGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:06:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752989Ab3AXLFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:05:55 -0500
Date: Thu, 24 Jan 2013 12:05:45 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        akpm@linux-foundation.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 repost] sched: cputime: avoid multiplication overflow
 (in common cases)
Message-ID: <20130124110545.GB2345@redhat.com>
References: <20130107113144.GA7544@redhat.com>
 <20130109183248.GA8293@somewhere.redhat.com>
 <20130110122621.GA13629@redhat.com>
 <CAFTL4hy9akOVvR=9erBx+4DzKS0x0D69vtVz0TO3op9+PH=euA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hy9akOVvR=9erBx+4DzKS0x0D69vtVz0TO3op9+PH=euA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 04:58:14PM +0100, Frederic Weisbecker wrote:
> Cool! So I can add your acked-by, right? I'll send this patch to Ingo soon.

Sure.

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

Thanks
Stanislaw
