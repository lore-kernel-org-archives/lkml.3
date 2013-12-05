Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3LEK7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:59:21 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:59511 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755011Ab3LEK7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:59:20 -0500
Date: Thu, 5 Dec 2013 11:59:14 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 00/38] perf/core improvements and fixes
Message-ID: <20131205105914.GA20558@gmail.com>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
 <20131205100429.GC16749@gmail.com>
 <20131205103707.GC21600@krava.brq.redhat.com>
 <20131205105344.GD20283@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205105344.GD20283@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> > never saw that one.. starting your test on 24 CPUs server now
> 
> I saw it again on a system by running two parallel build jobs:
> 
>   D=/tmp/perf-1; mkdir -p $D; while make O=$D install; do make O=$D clean; done
>   D=/tmp/perf-2; mkdir -p $D; while make O=$D install; do make O=$D clean; done

I'm running it now with the previous perf/core - no failures so far, 
after dozens of build passes.

Thanks,

	Ingo
