Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaJARMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 13:12:32 -0400
Received: from mail.kernel.org ([198.145.19.201]:40154 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260AbaJARMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 13:12:30 -0400
Date: Wed, 1 Oct 2014 14:12:26 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Tuan Bui <tuan.d.bui@hp.com>, linux-kernel@vger.kernel.org, dbueso@suse.de,
        a.p.zijlstra@chello.nl, paulus@samba.org, artagnon@gmail.com,
        jolsa@redhat.com, dvhart@linux.intel.com,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Jason Low <jason.low2@hp.com>, akpm@linux-foundation.org
Subject: Re: [RFC PATCH] Perf Bench: Locking Microbenchmark
Message-ID: <20141001171226.GF2799@kernel.org>
References: <1412120999.2941.11.camel@u64>
 <20141001052832.GA32248@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141001052832.GA32248@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Oct 01, 2014 at 07:28:32AM +0200, Ingo Molnar escreveu:
> If you compare an strace of AIM7 steady state and 'perf bench 
> lock' steady state, is it comparable, i.e. do the syscalls and 

Isn't "lock" too generic? Isn't this stressing some specific lock and if
so shouldn't that be made abundantly clear in the 'perf bench' test name
and in the docs?

Or is this the case that it started by using 'creat' calls to stress
some locking and will go on adding more syscalls to stress more kernel
locks?

- Arnaldo
