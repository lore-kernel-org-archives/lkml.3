Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab3KKPpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:45:14 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:48566 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab3KKPpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:45:11 -0500
Date: Mon, 11 Nov 2013 16:45:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Rodrigo Campos <rodrigo@sdfg.com.ar>, Arun Sharma <asharma@fb.com>
Subject: Re: [RFC/PATCHSET 00/14] perf report: Add support to accumulate hist
 periods (v2)
Message-ID: <20131111154506.GE26853@localhost.localdomain>
References: <87txfrxlq8.fsf@sejong.aot.lge.com>
 <20131105115802.GA12045@gmail.com>
 <87ppqex8tj.fsf@sejong.aot.lge.com>
 <20131106083046.GA4655@gmail.com>
 <87r4atx51i.fsf@sejong.aot.lge.com>
 <20131106114701.GA20249@gmail.com>
 <20131106121440.GB7919@localhost.localdomain>
 <20131111121352.GB21397@gmail.com>
 <20131111130844.GB26853@localhost.localdomain>
 <20131111135637.GD8781@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111135637.GD8781@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 02:56:37PM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Mon, Nov 11, 2013 at 01:13:52PM +0100, Ingo Molnar wrote:
> > > 
> > > It's not an irrelevant feature at all! :-)
> > > 
> > > It's just that for any sort of longer profile it was pretty 
> > > difficult/frustrating to use, which I think held back adoption.
> > > 
> > > That performance problem got fixed now by you and Namhyung, so I think 
> > > we'll see even wider adoption of call-graph profiling...
> > 
> > Ah I see now. At the time Linus reported his issue, I had the feeling 
> > his usecase was a bit "extreme", but I actually have no idea how far 
> > perf can be used given that I'm mostly used to short benchmarks, 
> > typically hackbench, perf bench sched messaging et al. Thing is I don't 
> > use it enough for my real usecases :)
> 
> Well, it's a bit of a catch-22: if there are severe scalability problems 
> for a usecase then people won't use it because they cannot use it. So 
> developers should usually try to over-measure things and go for extreme 
> uses and such.

Agreed :)
