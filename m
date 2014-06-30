Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbaF3PEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:04:06 -0400
Received: from mail.kernel.org ([198.145.19.201]:41781 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752499AbaF3PED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:04:03 -0400
Date: Mon, 30 Jun 2014 12:03:59 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 05/18] perf tools: Add ordered_events_(get|put) interface
Message-ID: <20140630150359.GC4762@kernel.org>
References: <1403103539-16807-1-git-send-email-jolsa@kernel.org>
 <1403103539-16807-6-git-send-email-jolsa@kernel.org>
 <53ADF8FC.5030604@gmail.com>
 <20140629163933.GA1407@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140629163933.GA1407@krava.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Jun 29, 2014 at 06:39:33PM +0200, Jiri Olsa escreveu:
> On Fri, Jun 27, 2014 at 05:06:36PM -0600, David Ahern wrote:
> > On 6/18/14, 8:58 AM, Jiri Olsa wrote:
> > >+static struct ordered_event*
> > >+ordered_events_get(struct ordered_events_queue *q, u64 timestamp)

Also I don't think that it matters that much to have explicit in the
name above the data structure used to reorder events, i.e. I suggest
renaming "struct ordered_events_queue" to just "struct ordered_events".

- Arnaldo
