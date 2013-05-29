Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966140Ab3E2NMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:12:43 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:55596 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934233Ab3E2NMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:12:41 -0400
Date: Wed, 29 May 2013 09:17:13 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: OOPS in perf_mmap_close()
In-Reply-To: <20130529074433.GB12193@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1305290915400.2479@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1305221953370.11450@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305222344060.12929@vincent-weaver-1.um.maine.edu> <20130523044803.GA25399@ZenIV.linux.org.uk> <20130523125218.GB23650@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305231006280.17701@vincent-weaver-1.um.maine.edu> <20130523152611.GE23650@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu> <20130528085548.GA12193@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1305281217370.19080@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1305281418120.19080@vincent-weaver-1.um.maine.edu> <20130529074433.GB12193@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 May 2013, Peter Zijlstra wrote:

> Hurm.. I don't suppose you have an easy reproducer handy eh? I'll go
> stare at it. At least the current state is better than before, but
> clearly we're not quite there yet.

I've been working on a reproducible test case.  Simple modifications to 
the existing testcase don't seem to trigger things.  I have a 100k-300k 
syscall trace that triggers things, I'm working on trying to get that down 
to something reasonable.

Vince
