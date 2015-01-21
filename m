Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012AbbAUMEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:04:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbbAUMEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:04:36 -0500
Date: Wed, 21 Jan 2015 13:03:23 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
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
Message-ID: <20150121120322.GB7869@krava.brq.redhat.com>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
 <54BEDE9B.2000900@gmail.com>
 <20150121061439.GC15963@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121061439.GC15963@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 07:14:40AM +0100, Ingo Molnar wrote:
> 
> * David Ahern <dsahern@gmail.com> wrote:
> 
> > On 1/20/15 9:38 AM, Jiri Olsa wrote:
> > >The patchset is also available in:
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> > >   perf/build
> > 
> > Do I have to guess which branch?
> > 
> > $ git branch -a | grep jirka | grep build
> >   remotes/jirka/perf/build
> >   remotes/jirka/perf/build_1
> >   remotes/jirka/perf/build_3
> >   remotes/jirka/perf/build_4
> >   remotes/jirka/perf/build_6
> >   remotes/jirka/perf/buildid_3
> >   remotes/jirka/perf/buildid_4
> >   remotes/jirka/perf/core_buildid_cache_clean
> >   remotes/jirka/perf/kbuild1
> >   remotes/jirka/perf/kbuild2
> >   remotes/jirka/perf/kbuild3
> >   remotes/jirka/perf/kbuild4
> >   remotes/jirka/perf/kbuild7
> >   remotes/jirka/perf/kbuild9
> 
> I used 'perf/build' as announced, and it gave the same diffstat 
> as the announcement. I guess the rest are WIP branches?

yep, it's the 'perf/build'

I have pushed many devel branches due to testing on all
those architectures.. I'll cleanup to avoid confusions ;-)

jirka
