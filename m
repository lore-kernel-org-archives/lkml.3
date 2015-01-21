Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbbAUMDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:03:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbbAUMDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:03:17 -0500
Date: Wed, 21 Jan 2015 13:01:54 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexis Berlemont <alexis.berlemont@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Anton Blanchard <anton@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
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
Message-ID: <20150121120154.GA7869@krava.brq.redhat.com>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
 <20150121061304.GB15963@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121061304.GB15963@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 07:13:04AM +0100, Ingo Molnar wrote:
> 
> * Jiri Olsa <jolsa@kernel.org> wrote:
> 
> > hi,
> > I'm following up on latest post from Alexis:
> >   http://marc.info/?l=linux-kernel&m=141427580405357&w=2
> > 
> > v3 changes:
> >   - disabling only builtin rules, keeping builtin variables in place
> >     because some projects we depends on using them (traceevent) [David]
> >   - fixed empy source list issue that happened on arm [Will, Mark]
> >   - updated to the current Arnaldo's perf/core branch
> >   - added automated tests into: tools/build/tests/
> >   - tested on arm64,ppc64,s390,x86_64,i386
> > 
> > v2 changes:
> >   - build Makefiles librarized and moved to 'tools/build' [Ingo]
> >   - several minor fixies [Namhyung]
> >   - tested on other archs now - x86_64, i386, powerpc
> >   - moved tools/lib/* under new build framework to show
> >     that it's possible ;-)
> >     included traceevent/lockdep maintainers to get the feedback
> >   - omitted last 2 patches
> > 
> > The patchset is also available in:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
> >   perf/build
> > 
> > All tests/make tests passed.
> 
> Very nice! I gave it a quick test and saw no problems, behavior, 
> speed and functionality of the build appears to be identical to 
> the old system.
> 
> > Also now we have the full dependency check ((gcc -Wp,-MD,... 
> > stuff) and build command line is stored/checked automatically 
> > by the build system.
> 
> Btw., another thing that might be nice to extract into 
> tools/build/ [or tools/config/] is the build/OS features 
> detection framework - it goes hand in hand with the build
> system.

right, it's on my TODO list ;-)

jirka
