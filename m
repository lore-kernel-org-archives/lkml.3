Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbaCKDAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 23:00:00 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:5052 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbaCKC77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 22:59:59 -0400
Message-ID: <1394506796.3867.23.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCHSET 0/9] perf tools: Update on filtered entries'
 percentage output (v7)
From: Davidlohr Bueso <davidlohr@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Date: Mon, 10 Mar 2014 19:59:56 -0700
In-Reply-To: <1394506703.3867.22.camel@buesod1.americas.hpqcorp.net>
References: <1394437440-11609-1-git-send-email-namhyung@kernel.org>
	 <20140310220819.GL22728@two.firstfloor.org>
	 <1394506703.3867.22.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-10 at 19:58 -0700, Davidlohr Bueso wrote:
> On Mon, 2014-03-10 at 23:08 +0100, Andi Kleen wrote:
> > On Mon, Mar 10, 2014 at 04:43:51PM +0900, Namhyung Kim wrote:
> > > Hello,
> > > 
> > > I added --percentage option to perf report to control display of
> > > percentage of filtered entries.
> > > 
> > >  usage: perf report [<options>]
> > > 
> > >         --percentage <relative|absolute>
> > >                           how to display percentage of filtered entries
> > 
> > Just as a high level comment. We have a lot of different display 
> > options now. It's hard to figure out what they all do for non experts.
> > 
> > It may be useful to define a number of high level layout combinations
> > that are useful for different situations and have a single
> > option to select everything together.
> 
> Yes please, absolutely. The wiki page could use some love as well. I
> imagine the manpage is updated but it's also nice to have some examples
> of the newer features in perf.wiki.kernel.org.

That reminds me, I should add an entry for perf-bench... lead by
example :S

