Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab3CRTGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 15:06:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769Ab3CRTGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 15:06:09 -0400
Date: Mon, 18 Mar 2013 20:05:49 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCHv3] perf: Fix vmalloc ring buffer free function
Message-ID: <20130318190548.GA18920@krava.brq.redhat.com>
References: <1363023885.14933.16.camel@laptop>
 <20130311180229.GI13679@krava.brq.redhat.com>
 <20130312100502.GC1348@krava.brq.redhat.com>
 <1363084030.14933.23.camel@laptop>
 <20130312135219.GA32001@krava.brq.redhat.com>
 <1363101972.24558.3.camel@laptop>
 <20130312153609.GC32001@krava.brq.redhat.com>
 <1363105490.24558.12.camel@laptop>
 <20130312170416.GD32001@krava.brq.redhat.com>
 <20130313111557.GC1064@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130313111557.GC1064@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 12:15:57PM +0100, Jiri Olsa wrote:
> On Tue, Mar 12, 2013 at 06:04:16PM +0100, Jiri Olsa wrote:
> > On Tue, Mar 12, 2013 at 05:24:50PM +0100, Peter Zijlstra wrote:
> > > Right you are..
> > > 
> > > How about something like the below; using that 0 << -1 is still 0.
> > 
> > hum.. we are obviously not on the same page wrt 'confusing' ;-)
> > 
> > looks ok, I'll test it
> 
> hi, it work's fine..
> 
> Tested-by: Jiri Olsa <jolsa@redhat.com>

are you going to include that, or should I repost it?

thanks,
jirka
