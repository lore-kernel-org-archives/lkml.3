Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbaJ0O2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:28:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:5699 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbaJ0O2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:28:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,796,1406617200"; 
   d="scan'208";a="626244199"
Date: Mon, 27 Oct 2014 07:28:18 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@kernel.org, tglx@linutronix.de,
        eranian@google.com, dzickus@redhat.com, jmario@redhat.com,
        acme@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Attempt to cleanup the HSW offcore bits
Message-ID: <20141027142818.GA3041@tassilo.jf.intel.com>
References: <20141023105119.173457103@infradead.org>
 <20141027122340.GU12538@two.firstfloor.org>
 <20141027130712.GF3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027130712.GF3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 02:07:12PM +0100, Peter Zijlstra wrote:
> On Mon, Oct 27, 2014 at 01:23:40PM +0100, Andi Kleen wrote:
> > On Thu, Oct 23, 2014 at 12:51:19PM +0200, Peter Zijlstra wrote:
> > > So Don asked about offcore and because I forgot I looked at the code and found
> > > the terrible mess Andi created with the HSW/BDW bits.
> > > 
> > > This series attempts to clean some of that up but seeing how it was all magic
> > > numbers 
> > 
> > All the bits are documented. The actual definitions are available
> > in the JSON offcore definitions at https://download.01.org/perfmon/
> 
> Yeah, no. That's not how we write code. Also, there's no actual JSON
> offcore file for HSW only some TSV file, and I've no mind to go decode

https://download.01.org/perfmon/HSW/Haswell_matrix_V14.json
https://download.01.org/perfmon/HSW/Haswell_matrix_bit_definitions_V14.json

-Andi
