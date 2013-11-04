Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab3KDTBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 14:01:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab3KDTBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 14:01:45 -0500
Date: Mon, 4 Nov 2013 20:01:24 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Joe Mario <jmario@redhat.com>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH 0/3] perf tools: Add perf_event_max_sample_rate freq check
Message-ID: <20131104190124.GA11287@krava.brq.redhat.com>
References: <1383563173-17466-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383563173-17466-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 12:06:10PM +0100, Jiri Olsa wrote:
> hi,
> adding the check for maximum allowed frequency rate
> defined in perf_event_max_sample_rate.
> 
> Plus procfs mountpoint reading code. Reachable here:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
>   perf/cc

oops, ^^^ should be 'perf/max_rate'

jirka
