Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab3FEPzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:55:53 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:51337 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab3FEPzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:55:51 -0400
Date: Wed, 5 Jun 2013 11:54:52 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: OOPS in perf_mmap_close()
In-Reply-To: <20130603192505.GH8923@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1306051151570.6484@vincent-weaver-1.um.maine.edu>
References: <20130523152611.GE23650@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1305231936210.2452@vincent-weaver-1.um.maine.edu> <20130528085548.GA12193@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1305281217370.19080@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1305281418120.19080@vincent-weaver-1.um.maine.edu> <20130529074433.GB12193@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1305291516310.2609@vincent-weaver-1.um.maine.edu> <20130530072532.GF4341@laptop>
 <alpine.DEB.2.10.1305300842040.11264@vincent-weaver-1.um.maine.edu> <20130603132645.GC8923@twins.programming.kicks-ass.net> <20130603192505.GH8923@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Jun 2013, Peter Zijlstra wrote:

> Seems to cure it... I'm going to let it run over night.

[sorry for the delay in testing, was at the hospital waiting for
 a new baby, and the free wi-fi had the ssh port blocked]

I'm running 3.10-rc4 with your patch plus the 3-line fixup applied and my 
various tests are solid so far.

It would be nice to get this applied, without the patch it's trivial to 
oops/lock any kernel going back to 3.2 and probably earlier (I haven't 
tested older than 3.2 yet).

Vince
