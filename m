Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab3LJKM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:12:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab3LJKMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:12:23 -0500
Date: Tue, 10 Dec 2013 11:12:02 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 1/2] perf report: Add --header/--header-only options
Message-ID: <20131210101202.GB8108@krava.brq.redhat.com>
References: <1386583370-1699-1-git-send-email-jolsa@redhat.com>
 <1386583370-1699-2-git-send-email-jolsa@redhat.com>
 <87ppp5lg2t.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ppp5lg2t.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 09:12:10AM +0900, Namhyung Kim wrote:
> On Mon,  9 Dec 2013 11:02:49 +0100, Jiri Olsa wrote:
> > Currently the perf.data header is always displayed for stdio
> > output, which is no always useful.
> >
> > Disabling header information by default and adding following
> > options to control header output:
> >   --header      - display header information (old default)
> >   --header-only - display header information only w/o further
> >                   processing, forces stdio output
> >
> [SNIP]
> > +--header
> > +	Show perf.data header.
> 
> This explanation looks too terse.  How about this?
> 
> 	Show header information in the perf.data file.  This includes
>         various information like hostname, os and perf version, cpu/mem
>         info, perf command line, event list and so on.  Currently only
>         --stdio output supports this feature.

sounds good, I will use it

thanks,
jirka
