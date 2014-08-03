Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaHCRaf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 13:30:35 -0400
Received: from one.firstfloor.org ([193.170.194.197]:33233 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaHCRae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 13:30:34 -0400
Date: Sun, 3 Aug 2014 19:30:31 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Sergey Oboguev <oboguev.public@gmail.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        khalid.aziz@oracle.com
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
Message-ID: <20140803173031.GQ18735@two.firstfloor.org>
References: <CA+80gGYVjprinWEJWbVq4VxjOLjQri8EvGAJ+sx+ihcOxdstCA@mail.gmail.com>
 <8738dm9t4z.fsf@tassilo.jf.intel.com>
 <1406532289.5133.223.camel@marge.simpson.net>
 <CA+80gGaohO-RaG0_tWZJEFzisrrBpgfiw-mxMrTfSK0N=k7gQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+80gGaohO-RaG0_tWZJEFzisrrBpgfiw-mxMrTfSK0N=k7gQA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (One example might be virtual machine that runs guest operating system that is
> not paravirtualized or can be paravirtualized only to a limited extent. The VM
> might guess that preemption of VCPU thread that is processing events such as
> IPI interrupts, clock interrupts or certain device interrupts is likely to
> cause overall performance degradation due to other VCPUs spinning for an IPI
> response or spinning waiting for a spinlock, and thought the general kinds of
> these dependencies may be foreseen, but actual dependency chains between VCPUs
> cannot be established at run time.)

PAUSE loop exiting (PLE) can handle it in limited fashion on VMs
even without paravirtualization.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
