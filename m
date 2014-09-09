Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266AbaIITIV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:08:21 -0400
Received: from mail.kernel.org ([198.145.19.201]:50053 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbaIITIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:08:19 -0400
Date: Tue, 9 Sep 2014 16:08:12 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Kyle McMartin <kyle@mcmartin.ca>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Subject: Re: [GIT PULL 00/13] perf/core improvements and fixes
Message-ID: <20140909190812.GA5917@kernel.org>
References: <1410211089-28668-1-git-send-email-acme@kernel.org>
 <540EBED4.70900@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540EBED4.70900@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 09, 2014 at 11:48:20AM +0300, Adrian Hunter escreveu:
> On 09/09/2014 12:17 AM, Arnaldo Carvalho de Melo wrote:
> > Hi Ingo,
> > 
> > 	Please consider pulling,
> > 
> > - Arnaldo
> 
> I am very sorry Arnaldo but 2 patches are older versions, namely:
> 
> 	perf tools: Build programs to copy 32-bit compatibility VDSOs
> 	perf tools: Add support for 32-bit compatibility VDSOs
> 
> Up-to-date versions can be found from 15 August:
> 
> 	patchwork:
> 
> 		https://patchwork.kernel.org/patch/4729131/
> 		https://patchwork.kernel.org/patch/4729111/

Ok, those don't apply, as it expects other stuff, that you sent before,
but were not processed yet, to be in place, I'm fixing it up.

- Arnaldo
 
> 	marc.info:
> 
> 		http://marc.info/?l=linux-kernel&m=140812995414607&w=4
> 		http://marc.info/?l=linux-kernel&m=140812993814585&w=4
> 
> It looks like I reposted older versions by mistake on 31 July.
> Very sorry :-(
> 
> The originals were changed as described here:
> 
> 	http://marc.info/?l=linux-kernel&m=140621020918615
> 	http://marc.info/?l=linux-kernel&m=140618721010170
> 
> > 
> > The following changes since commit 39b5a56ec0be5effe9b7d0f18cb27724bf2e5d47:
> > 
> >   Merge branch 'rfc/perf' into perf/core, because it's ready for inclusion (2014-08-24 22:35:42 +0200)
> > 
> > are available in the git repository at:
> > 
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo
> > 
> > for you to fetch changes up to fa3480cb0a96c8af9ded1a8c836c91bd5704bda1:
> > 
> >   perf tools: Add perf_pmu__scan_file() (2014-09-08 17:16:06 -0300)
> > 
> > ----------------------------------------------------------------
> > perf/core improvements and fixes:
> > 
> > User visible:
> > 
> > o Add +field argument support for --sort option (Jiri Olsa)
> > 
> > Infrastructure:
> > 
> > o More intel PT prep work, from Adrian Hunter, including:
> > 
> >   - Let a user specify a PMU event without any config terms
> >   - Add perf-with-kcore script
> >   - Build programs to copy 32-bit compatibility VDSOs
> >   - Add support for 32-bit compatibility VDSOs
> >   - Let default config be defined for a PMU
> >   - Add perf_pmu__scan_file()
> > 
> > o Add feature checks to .gitignore (Alexander Shishkin)
> > 
> > o "perf kvm stat report" improvements by Alexander Yarygin:
> >   o  Save pid string in opts.target.pid
> >   o  Enable the target.system_wide flag
> >   o  Unify the title bar output
> > 
> > o Fix build issue on powerpc when DWARF support is disabled (Anton Blanchard)
> > 
> > o Allow to specify lib compile variable for spec usage (Jiri Olsa)
> > 
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > ----------------------------------------------------------------
> > Adrian Hunter (6):
> >       perf tools: Let a user specify a PMU event without any config terms
> >       perf tools: Add perf-with-kcore script
> >       perf tools: Build programs to copy 32-bit compatibility VDSOs
> >       perf tools: Add support for 32-bit compatibility VDSOs
> >       perf tools: Let default config be defined for a PMU
> >       perf tools: Add perf_pmu__scan_file()
> > 
> > Alexander Shishkin (1):
> >       perf tools: Add feature checks to .gitignore
> > 
> > Alexander Yarygin (3):
> >       perf kvm stat report: Save pid string in opts.target.pid
> >       perf kvm stat report: Enable the target.system_wide flag
> >       perf kvm stat report: Unify the title bar output
> > 
> > Anton Blanchard (1):
> >       perf tools powerpc: Fix build issue when DWARF support is disabled
> > 
> > Jiri Olsa (2):
> >       perf tools: Add +field argument support for --sort option
> >       perf tools: Allow to specify lib compile variable for spec usage
> > 
> >  tools/perf/.gitignore            |   2 +
> >  tools/perf/Makefile.perf         |  42 ++++++-
> >  tools/perf/arch/powerpc/Makefile |   2 +-
> >  tools/perf/builtin-kvm.c         |  23 ++--
> >  tools/perf/config/Makefile       |  33 ++++-
> >  tools/perf/config/Makefile.arch  |   8 ++
> >  tools/perf/perf-read-vdso.c      |  59 +++++++++
> >  tools/perf/perf-with-kcore.sh    | 259 +++++++++++++++++++++++++++++++++++++++
> >  tools/perf/tests/pmu.c           |   2 +-
> >  tools/perf/util/kvm-stat.h       |   1 -
> >  tools/perf/util/parse-events.c   |  13 +-
> >  tools/perf/util/parse-events.y   |  10 ++
> >  tools/perf/util/pmu.c            |  79 +++++++++---
> >  tools/perf/util/pmu.h            |  12 +-
> >  tools/perf/util/sort.c           |  37 +++++-
> >  tools/perf/util/vdso.c           | 170 ++++++++++++++++++++++++-
> >  tools/perf/util/vdso.h           |   4 +-
> >  17 files changed, 712 insertions(+), 44 deletions(-)
> >  create mode 100644 tools/perf/perf-read-vdso.c
> >  create mode 100644 tools/perf/perf-with-kcore.sh
> > 
> > 
