Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab3A1Jc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:32:57 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:49323 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3A1Jcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:32:55 -0500
Date: Mon, 28 Jan 2013 17:32:42 +0800
From: Wang YanQing <udknight@gmail.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Milton Miller <miltonm@bga.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        mina86@mina86.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH]smp: Fix send func call IPI to empty cpu mask
Message-ID: <20130128093242.GA5964@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Milton Miller <miltonm@bga.com>, Mike Galbraith <efault@gmx.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	mina86@mina86.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	stable <stable@vger.kernel.org>
References: <20130126075357.GA3205@udknight>
 <CA+55aFyJ0tsvJeujyRwX=q5KPKjeejmvQOMTCJxDcaEmYprpvg@mail.gmail.com>
 <20130127155043.GA6214@gmail.com>
 <5106523302000078000B9F0B@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5106523302000078000B9F0B@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 09:25:55AM +0000, Jan Beulich wrote:
> But the patch is obviously incomplete for the CPUMASK_OFFSTACK
> case, as the newly added cpumask_ipi member never gets
> its bit array allocated.
> 
> Jan
Yes, I have found it, and the patch is in lkml some hours ago.

Thanks.
