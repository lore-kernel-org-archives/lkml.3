Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbaJ1Vxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:53:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:52762 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177AbaJ1Vxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:53:30 -0400
Date: Tue, 28 Oct 2014 22:53:08 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@linux.intel.com>
cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        mingo@kernel.org, eranian@google.com, dzickus@redhat.com,
        jmario@redhat.com, acme@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Attempt to cleanup the HSW offcore bits
In-Reply-To: <20141027142818.GA3041@tassilo.jf.intel.com>
Message-ID: <alpine.DEB.2.11.1410282243510.5308@nanos>
References: <20141023105119.173457103@infradead.org> <20141027122340.GU12538@two.firstfloor.org> <20141027130712.GF3337@twins.programming.kicks-ass.net> <20141027142818.GA3041@tassilo.jf.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Mon, 27 Oct 2014, Andi Kleen wrote:
> On Mon, Oct 27, 2014 at 02:07:12PM +0100, Peter Zijlstra wrote:
> > On Mon, Oct 27, 2014 at 01:23:40PM +0100, Andi Kleen wrote:
> > > On Thu, Oct 23, 2014 at 12:51:19PM +0200, Peter Zijlstra wrote:
> > > > So Don asked about offcore and because I forgot I looked at the code and found
> > > > the terrible mess Andi created with the HSW/BDW bits.
> > > > 
> > > > This series attempts to clean some of that up but seeing how it was all magic
> > > > numbers 
> > > 
> > > All the bits are documented. The actual definitions are available
> > > in the JSON offcore definitions at https://download.01.org/perfmon/
> > 
> > Yeah, no. That's not how we write code. Also, there's no actual JSON
> > offcore file for HSW only some TSV file, and I've no mind to go decode
> 
> https://download.01.org/perfmon/HSW/Haswell_matrix_V14.json
> https://download.01.org/perfmon/HSW/Haswell_matrix_bit_definitions_V14.json

Of course you did not answer any of the other legitimate questions
Peter brought up.

Care to answer them w/o pointing to magic json files which lack ANY
useful information about the magic bits they provide? And why they are
not consistent with the SDM?

Either you come forth with reasonable explanations or I'm going to rip
out the mess you created even before Peter can persuade himself to do
so. 

Thanks,

	tglx

