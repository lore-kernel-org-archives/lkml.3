Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739AbaJHWPB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:15:01 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:29500 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933687AbaJHWO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:14:57 -0400
Message-ID: <1412806493.2908.7.camel@u64>
Subject: Re: [RFC PATCH] Perf Bench: Locking Microbenchmark
From: Tuan Bui <tuan.d.bui@hp.com>
To: Davidlohr Bueso <dbueso@suse.de>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org,
        artagnon@gmail.com, jolsa@redhat.com, dvhart@linux.intel.com,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Jason Low <jason.low2@hp.com>, akpm@linux-foundation.org
Date: Wed, 08 Oct 2014 15:14:53 -0700
In-Reply-To: <1412312253.27162.5.camel@linux-t7sj.site>
References: <1412120999.2941.11.camel@u64>
	 <20141001052832.GA32248@gmail.com> <20141001171226.GF2799@kernel.org>
	 <1412312253.27162.5.camel@linux-t7sj.site>
Organization: HP
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 21:57 -0700, Davidlohr Bueso wrote:
> On Wed, 2014-10-01 at 14:12 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Wed, Oct 01, 2014 at 07:28:32AM +0200, Ingo Molnar escreveu:
> > > If you compare an strace of AIM7 steady state and 'perf bench 
> > > lock' steady state, is it comparable, i.e. do the syscalls and 
> > 
> > Isn't "lock" too generic? Isn't this stressing some specific lock and if
> > so shouldn't that be made abundantly clear in the 'perf bench' test name
> > and in the docs?
> 
> yeah, and 'perf bench locking creat' just doesn't sound right.
> 

Do you have any suggestion on how i should name it?

