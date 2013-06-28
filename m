Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab3F1VCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 17:02:15 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:64969 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab3F1VCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 17:02:13 -0400
Date: Fri, 28 Jun 2013 17:07:38 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: [testcase] perf: yet another fuzzer triggered crash
In-Reply-To: <alpine.DEB.2.10.1306281531070.10799@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1306281705340.10799@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1306121911500.12627@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306140058520.8617@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1306281531070.10799@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jun 2013, Vince Weaver wrote:

> On Fri, 14 Jun 2013, Vince Weaver wrote:
>  
> > OK, I haven't managed to get a small reproducible test case for the system 
> > crash yet
> 
> I wasted the last 2 days bisecting a 10000 syscall trace, but below is a 
> 20-syscall testcase that rapidly makes a core2 machine running 3.10-rc7 
> unusable.

and it turns out I might have bisected down too much, as though that 
crashes my core2 system it doesn't crash newer machines.

I'm too lazy to re-bisect today, but the much longer program here:
   http://web.eece.maine.edu/~vweaver/files/nmi_bug_snb.c
reliably causes the same crash on a Sandybridge machine I have running 3.9

Vince Weaver
vincent.weaver@maine.edu
http://www.eece.maine.edu/~vweaver/
