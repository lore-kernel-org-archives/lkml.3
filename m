Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848AbaBFN4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 08:56:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990AbaBFN4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 08:56:41 -0500
Date: Thu, 6 Feb 2014 11:56:27 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [BUG] perf top: --stdio causes continuous refresh
Message-ID: <20140206135627.GA26955@infradead.org>
References: <CABPqkBSkSbWvdRu3iEtNvHhfV4J4sALHvdd40hZTcGxLe576yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSkSbWvdRu3iEtNvHhfV4J4sALHvdd40hZTcGxLe576yQ@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Feb 05, 2014 at 10:25:09PM +0100, Stephane Eranian escreveu:
> If you run perf top on 3.14 but you force --stdio mode, perf top
> goes crazy and constantly refreshes the output.
> 
> It does that with many older versions of the perf as well on 3.14.
> It runs fine with newt mode.
> 
> Works fine with my 3.11 kernel. So something must be broken
> with 3.14.
 
> Can you reproduce the problem as well?

Not so far, using my perf/urgent branch:

[root@ssdandy ~]# perf --version
perf version 3.13.g1da187

Also it honours --delay, i.e.

# perf top --delay 5 --stdio

it will wait 5 seconds between refreshes, etc.

Checking out v3.14-rc1 now.

- Arnaldo
