Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbbAUGOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:14:47 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61245 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350AbbAUGOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:14:45 -0500
Date: Wed, 21 Jan 2015 07:14:40 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Anton Blanchard <anton@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Florian Fainelli <florian@openwrt.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jan Heylen <heyleke@gmail.com>, Mark Salter <msalter@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "S. Lockwood-Childs" <sjl@vctlabs.com>,
        Sam Ravnborg <sam@ravnborg.org>, Sasha Levin <sasha.levin@oracle.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCHv3 00/36] perf tools: New build framework
Message-ID: <20150121061439.GC15963@gmail.com>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
 <54BEDE9B.2000900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BEDE9B.2000900@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 1/20/15 9:38 AM, Jiri Olsa wrote:
> >The patchset is also available in:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> >   perf/build
> 
> Do I have to guess which branch?
> 
> $ git branch -a | grep jirka | grep build
>   remotes/jirka/perf/build
>   remotes/jirka/perf/build_1
>   remotes/jirka/perf/build_3
>   remotes/jirka/perf/build_4
>   remotes/jirka/perf/build_6
>   remotes/jirka/perf/buildid_3
>   remotes/jirka/perf/buildid_4
>   remotes/jirka/perf/core_buildid_cache_clean
>   remotes/jirka/perf/kbuild1
>   remotes/jirka/perf/kbuild2
>   remotes/jirka/perf/kbuild3
>   remotes/jirka/perf/kbuild4
>   remotes/jirka/perf/kbuild7
>   remotes/jirka/perf/kbuild9

I used 'perf/build' as announced, and it gave the same diffstat 
as the announcement. I guess the rest are WIP branches?

Thanks,

	Ingo
