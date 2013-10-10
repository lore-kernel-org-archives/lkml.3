Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab3JJMtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 08:49:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37628 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab3JJMtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 08:49:09 -0400
Date: Thu, 10 Oct 2013 14:48:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V6 0/8] perf tools: kcore improvements
Message-ID: <20131010124843.GM3081@twins.programming.kicks-ass.net>
References: <1381320078-16497-1-git-send-email-adrian.hunter@intel.com>
 <20131009120744.GF3081@twins.programming.kicks-ass.net>
 <874n8qyt3z.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874n8qyt3z.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 03:30:56PM -0700, Andi Kleen wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
> 
> > On Wed, Oct 09, 2013 at 03:01:10PM +0300, Adrian Hunter wrote:
> >> 	- workaround objdump difficulties with kcore
> >
> > I've no idea, but given that've 'inlined' addr2line, should we also
> > consider polling in objdump -- or at least that subset of functionality
> > that we actually use?
> 
> FWIW addr2line is just a straight forward BFD call.
> 
> objdump is significantly more complex, a lot of it is outside BFD
> (including the full disassembler and all the logic for syncing
> the source files)

Oh, that's unfortunate, I was hoping most of that would indeed be in
some library form or other.
