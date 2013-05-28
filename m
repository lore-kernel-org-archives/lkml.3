Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934784Ab3E1QOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 12:14:40 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:52406 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934728Ab3E1QOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 12:14:38 -0400
Date: Tue, 28 May 2013 12:19:11 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: OOPS in perf_mmap_close()
In-Reply-To: <20130528085548.GA12193@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1305281217370.19080@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1305221523420.9944@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu> <20130523044803.GA25399@ZenIV.linux.org.uk>
 <20130523125218.GB23650@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1305231006280.17701@vincent-weaver-1.um.maine.edu> <20130523152611.GE23650@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu>
 <20130528085548.GA12193@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 May 2013, Peter Zijlstra wrote:
 
> Take 2.. :-)
> 
> Leaving the locked vs pinned debacle for another time. The below patch
> survives many non-priv execution of the problem prog.

It looks like this is already in tip, but I can confirm that this 
patch seems to fix things on my machine and holds up against longer 
fuzzing runs.

Thanks,

Vince
