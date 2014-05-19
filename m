Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbaESPyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:54:11 -0400
Received: from alerce.vps.bitfolk.com ([85.119.82.134]:45150 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355AbaESPyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:54:09 -0400
X-Greylist: delayed 2501 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 May 2014 11:54:09 EDT
Date: Mon, 19 May 2014 16:11:20 +0100
From: Rodrigo Campos <rodrigo@sdfg.com.ar>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Arun Sharma <asharma@fb.com>
Subject: Re: [PATCHSET 00/21] perf tools: Add support to accumulate hist
 periods (v9)
Message-ID: <20140519151120.GE24333@sdfg.com.ar>
References: <1395293806-25847-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395293806-25847-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 02:36:25PM +0900, Namhyung Kim wrote:
> Hello,
> 
> This is a new attempt to implement cumulative hist period report.
> This work begins from Arun's SORT_INCLUSIVE patch [1] but I completely
> rewrote it from scratch.
> 
> This version depends on my previous percentage patchset [2] and output
> field patchset[3].  So please test this again although there's not
> much change in the series itself.
> 
> This patchset basically adds period in a sample to every node in the
> callchain.  A hist_entry now has an additional fields to keep the
> cumulative period if --children option is given on perf report.
> 
> I changed the option as a separate --children and added a new
> "Children" column (and renamed the default "Overhead" column into
> "Self").  The output will be sorted by children (cumulative) overhead
> for now.  It also adds 'overhead_children' field to -F/--fields option
> to be selected by user and it'll show you "N/A" if the cumulation is
> not supported (due to missing callchain).


Is there something I can help to have this merged ? As far as I tested, this
works fine here. Or is this ok, just waiting on the "perf report: Add -F option for
specifying output fields" patchset ?






Thanks a lot,

Rodrigo
