Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaCJWIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 18:08:23 -0400
Received: from one.firstfloor.org ([193.170.194.197]:46714 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaCJWIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 18:08:21 -0400
Date: Mon, 10 Mar 2014 23:08:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCHSET 0/9] perf tools: Update on filtered entries'
 percentage output (v7)
Message-ID: <20140310220819.GL22728@two.firstfloor.org>
References: <1394437440-11609-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394437440-11609-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 04:43:51PM +0900, Namhyung Kim wrote:
> Hello,
> 
> I added --percentage option to perf report to control display of
> percentage of filtered entries.
> 
>  usage: perf report [<options>]
> 
>         --percentage <relative|absolute>
>                           how to display percentage of filtered entries

Just as a high level comment. We have a lot of different display 
options now. It's hard to figure out what they all do for non experts.

It may be useful to define a number of high level layout combinations
that are useful for different situations and have a single
option to select everything together.

Perhaps --layout FOO and FOO a number of predefined layouts.

-Andi
