Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573Ab3H1NbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 09:31:18 -0400
Received: from mail-ye0-f172.google.com ([209.85.213.172]:49188 "EHLO
	mail-ye0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab3H1NbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 09:31:17 -0400
Date: Wed, 28 Aug 2013 10:31:10 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 2/3] perf trace: Add option to analyze events in a file
 versus live
Message-ID: <20130828133110.GD31260@ghostprotocols.net>
References: <1377575535-43544-1-git-send-email-dsahern@gmail.com>
 <1377575535-43544-3-git-send-email-dsahern@gmail.com>
 <20130828130258.GC31260@ghostprotocols.net>
 <521DF691.7080706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521DF691.7080706@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 28, 2013 at 07:09:37AM -0600, David Ahern escreveu:
> On 8/28/13 7:02 AM, Arnaldo Carvalho de Melo wrote:
> >Em Mon, Aug 26, 2013 at 09:52:14PM -0600, David Ahern escreveu:
> >>Allows capture of raw_syscall:* events and analyzed at a later
> >>time.

> >>+-r
> >>+--replay
> >>+	Process events from a given perf data file.

> >Shouldn't this be just -i/--input, like for 'report', 'annotate', etc?
 
> uh, arguably. But -i == inherit per a prior patch. record (-i =
> inherit) / report (-i = input file) collision.

Perhaps --inherit is seldom used and can stay just as --inherit so that
we can use -i/--input to keep it consistent with report/annotate/etc?

- Arnaldo
