Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbaBEUUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:20:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59175 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbaBEUUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:20:32 -0500
Date: Wed, 5 Feb 2014 21:20:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: junk@eslaf.co.uk, alan@lxorguk.ukuu.org.uk, Ingo Molnar <mingo@kernel.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf,x86,p6: Add userspace RDPMC quirk for P6
Message-ID: <20140205202024.GQ2936@laptop.programming.kicks-ass.net>
References: <20140205102718.GF3229@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1402051415190.16225@pianoman.cluster.toy>
 <20140205192012.GL2936@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.02.1402051427210.16596@pianoman.cluster.toy>
 <alpine.DEB.2.02.1402051435540.16859@pianoman.cluster.toy>
 <20140205195506.GN2936@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.02.1402051501240.17670@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402051501240.17670@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 05, 2014 at 03:04:03PM -0500, Vince Weaver wrote:
> mfg steping "sB1" which means processor stepping 9.  See page 15 of the 
> document linked in the original patch.

Might confusing way to write 9. ok, I'll make it that.
