Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab3LJLm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 06:42:28 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:60392 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab3LJLmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 06:42:25 -0500
Date: Tue, 10 Dec 2013 08:42:18 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/2] perf tools: Add --header/--header-only options
Message-ID: <20131210114218.GH8098@ghostprotocols.net>
References: <1386583370-1699-1-git-send-email-jolsa@redhat.com>
 <52A65169.2030705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A65169.2030705@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 09, 2013 at 04:25:29PM -0700, David Ahern escreveu:
> [Added Stephane given that he added the header output]

Yeah, I added him to the CC list in the patch when I merged it, Ingo had
asked me to do this quite some time ago, I also usually did:

$ perf report | grep -v ^#

When looking for the first few entries in a profile.

I think that with Namhyung's improvement to the man page + the single
line stating that --header should be used to get the previous behavior
we are ok, no?
 
> On 12/9/13, 3:02 AM, Jiri Olsa wrote:
> >Currently the perf.data header is always displayed for stdio
> >output, which is no always useful.

> >Disabling header information by default and adding following
> >options to control header output:
> >   --header      - display header information (old default)
> >   --header-only - display header information only w/o further
> >                   processing.

> I've been getting annoyed but that as well. Very useful on the first
> run; overhead after that.

> Acked-by: David Ahern <dsahern@gmail.com>

I'll add this since I'll have to reprocess the last batch due to the
dso__delete problem.

- Arnaldo
