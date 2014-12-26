Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaLZODd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 09:03:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbaLZODc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 09:03:32 -0500
Date: Fri, 26 Dec 2014 15:02:34 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC/PATCHSET 00/37] perf tools: Speed-up perf report by using
 multi thread (v1)
Message-ID: <20141226140234.GB20929@krava.redhat.com>
References: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419405333-27952-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2014 at 04:14:56PM +0900, Namhyung Kim wrote:

SNIP

> 
> 
> You can get it from 'perf/threaded-v1' branch on my tree at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/namhyung/linux-perf.git
> 
> Please take a look and play with it.  Any comments are welcome! :)

very nice at first round check ;-)

I'll do detailed review next week

thanks,
jirka
