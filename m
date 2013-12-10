Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab3LJKLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 05:11:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398Ab3LJKLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 05:11:48 -0500
Date: Tue, 10 Dec 2013 11:11:17 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 0/2] perf tools: Add --header/--header-only options
Message-ID: <20131210101117.GA8108@krava.brq.redhat.com>
References: <1386583370-1699-1-git-send-email-jolsa@redhat.com>
 <87txehlgbm.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87txehlgbm.fsf@sejong.aot.lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 09:06:53AM +0900, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Mon,  9 Dec 2013 11:02:48 +0100, Jiri Olsa wrote:
> > Currently the perf.data header is always displayed for stdio
> > output, which is no always useful.
> >
> > Disabling header information by default and adding following
> > options to control header output:
> 
> Hmm.. I'm not sure it's OK to change the user-visible default behavior.
> At least we can provide help message for old users?

maybe we could display on the first line something like:
 
  $ perf report --stdio
  # To display data file header, please use --header/--header-only options.
  #
  # Samples: 12  of event 'cycles'
  # Event count (approx.): 3741156
  #
  # Overhead  Command      Shared Object                     Symbol
  # ........  .......  .................  .........................
  ...


jirka
