Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582AbaBETUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 14:20:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57440 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaBETUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:20:22 -0500
Date: Wed, 5 Feb 2014 20:20:12 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: junk@eslaf.co.uk, alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf,x86,p6: Add userspace RDPMC quirk for P6
Message-ID: <20140205192012.GL2936@laptop.programming.kicks-ass.net>
References: <20140205102718.GF3229@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1402051415190.16225@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402051415190.16225@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 02:16:43PM -0500, Vince Weaver wrote:
> On Wed, 5 Feb 2014, Peter Zijlstra wrote:
> 
> > P6 class machines can die hard when PCE gets enabled due to CPU
> > errata. The safe way it so disable it by default and keep it disabled.
> > 
> > See errata 26:
> 
> so you take an errata applicable to a subset of Pentium Pro steppings and 
> apply it to the whole p6 line (which includes the whole way up to Pentium 
> III)?
> 
> Or am I missing something in the documentation you link to?

I forgot it went all the way to P-III, let me try and find the other
erratas.
