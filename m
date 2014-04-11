Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbaDKGyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 02:54:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34374 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaDKGyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 02:54:04 -0400
Date: Fri, 11 Apr 2014 08:53:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Possible issue with commit 6f008e72cd - locking/mutex: Fix debug
 checks.
Message-ID: <20140411065357.GQ10526@twins.programming.kicks-ass.net>
References: <3817.1397172208@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3817.1397172208@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 07:23:28PM -0400, Valdis Kletnieks wrote:
> So recent linux-next lock up on my laptop due to a third-party module.
> Bisection finds this as the source of the issue:
> 
> 6f008e72cd111a119b5d8de8c5438d892aae99eb is the first bad commit
> commit 6f008e72cd111a119b5d8de8c5438d892aae99eb
> Author: Peter Zijlstra <peterz@infradead.org>
> Date:   Wed Mar 12 13:24:42 2014 +0100

see
http://lkml.kernel.org/r/20140410141559.GE13658@twins.programming.kicks-ass.net
