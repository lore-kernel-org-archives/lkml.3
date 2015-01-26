Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbbAZJW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 04:22:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbbAZJWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 04:22:22 -0500
Date: Mon, 26 Jan 2015 10:21:17 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
        Ingo Molnar <mingo@kernel.org>, Jan Heylen <heyleke@gmail.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "S. Lockwood-Childs" <sjl@vctlabs.com>,
        Sam Ravnborg <sam@ravnborg.org>, Sasha Levin <sasha.levin@oracle.com>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [PATCHv3 00/36] perf tools: New build framework
Message-ID: <20150126092117.GE13287@krava.brq.redhat.com>
References: <1421771973-6022-1-git-send-email-jolsa@kernel.org>
 <20150121172544.GP4549@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121172544.GP4549@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 05:25:45PM +0000, Will Deacon wrote:
> On Tue, Jan 20, 2015 at 04:38:57PM +0000, Jiri Olsa wrote:
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
> > 
> > Any feedback from ARM guys would be great ;-)
> 
> Works fine native on arm64:
> 
>   Tested-by: Will Deacon <will.deacon@arm.com>
> 
> Cheers,
> 
> Will

thanks!

jirka
