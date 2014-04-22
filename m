Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909AbaDVFDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 01:03:44 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:58985 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbaDVFDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 01:03:42 -0400
Date: Tue, 22 Apr 2014 07:03:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        hskinnemoen@gmail.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:locking/core] arch,avr32: Convert smp_mb__*()
Message-ID: <20140422050336.GA7784@gmail.com>
References: <tip-8gow97a7mapmnec0pvf729pj@git.kernel.org>
 <20140421192822.GA29890@samfundet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140421192822.GA29890@samfundet.no>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hans-Christian Egtvedt <egtvedt@samfundet.no> wrote:

> Around Fri 18 Apr 2014 06:05:23 -0700 or thereabout, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  710adaa913169d7183cdf0de41c2a349101ff615
> > Gitweb:     http://git.kernel.org/tip/710adaa913169d7183cdf0de41c2a349101ff615
> > Author:     Peter Zijlstra <peterz@infradead.org>
> > AuthorDate: Thu, 13 Mar 2014 19:00:37 +0100
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Fri, 18 Apr 2014 11:40:33 +0200
> > 
> > arch,avr32: Convert smp_mb__*()
> > 
> > AVR32's mb() implementation is a compiler barrier(), therefore it all
> > doesn't matter, fully rely on whatever asm-generic/barrier.h
> > generates.
> 
> Thanks for cleaning, would this go in through some tip-tree? Or would you
> prefer if I added it to my for-linus branch?

Yeah, the plan would be for this to go via the locking tree 
(tip:locking/core), for v3.16 - together with similar patches for 
other architectures.

Thanks,

	Ingo
