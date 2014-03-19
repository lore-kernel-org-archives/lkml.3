Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763AbaCSLj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 07:39:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58386 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758649AbaCSLj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 07:39:26 -0400
Date: Wed, 19 Mar 2014 12:39:23 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/4] sched/rt: Substract number throttled rt_rq's tasks
 from rq->nr_running
Message-ID: <20140319113923.GH27632@laptop.programming.kicks-ass.net>
References: <1394835217.18748.26.camel@HP-250-G1-Notebook-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394835217.18748.26.camel@HP-250-G1-Notebook-PC>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 02:13:37AM +0400, Kirill Tkhai wrote:
> This patchset makes RT class to fit generic scheme, which is used in fair and
> deadline classes.
> 
> Number of tasks of throttled rt_rq and its children is being decremented from
> rq->nr_running, when rt_rq becomes throlled.

Couldn't help yourself eh?

Thanks for cleaning that up!
