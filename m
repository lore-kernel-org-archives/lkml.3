Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197AbaJCE6C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 00:58:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaJCE6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 00:58:00 -0400
Message-ID: <1412312253.27162.5.camel@linux-t7sj.site>
Subject: Re: [RFC PATCH] Perf Bench: Locking Microbenchmark
From: Davidlohr Bueso <dbueso@suse.de>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Tuan Bui <tuan.d.bui@hp.com>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        artagnon@gmail.com, jolsa@redhat.com, dvhart@linux.intel.com,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Jason Low <jason.low2@hp.com>, akpm@linux-foundation.org
Date: Thu, 02 Oct 2014 21:57:33 -0700
In-Reply-To: <20141001171226.GF2799@kernel.org>
References: <1412120999.2941.11.camel@u64>
	 <20141001052832.GA32248@gmail.com> <20141001171226.GF2799@kernel.org>
Organization: SUSE Labs
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 14:12 -0300, Arnaldo Carvalho de Melo wrote:
> Em Wed, Oct 01, 2014 at 07:28:32AM +0200, Ingo Molnar escreveu:
> > If you compare an strace of AIM7 steady state and 'perf bench 
> > lock' steady state, is it comparable, i.e. do the syscalls and 
> 
> Isn't "lock" too generic? Isn't this stressing some specific lock and if
> so shouldn't that be made abundantly clear in the 'perf bench' test name
> and in the docs?

yeah, and 'perf bench locking creat' just doesn't sound right.

