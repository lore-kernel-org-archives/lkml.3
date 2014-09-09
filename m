Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbaIIItz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 04:49:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:47606 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756254AbaIIItu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 04:49:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,491,1406617200"; 
   d="scan'208";a="596703074"
Message-ID: <540EBED4.70900@intel.com>
Date: Tue, 09 Sep 2014 11:48:20 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
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
References: <1410211089-28668-1-git-send-email-acme@kernel.org>
In-Reply-To: <1410211089-28668-1-git-send-email-acme@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 12:17 AM, Arnaldo Carvalho de Melo wrote:
> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo

I am very sorry Arnaldo but 2 patches are older versions, namely:

	perf tools: Build programs to copy 32-bit compatibility VDSOs
	perf tools: Add support for 32-bit compatibility VDSOs

Up-to-date versions can be found from 15 August:

	patchwork:

		https://patchwork.kernel.org/patch/4729131/
		https://patchwork.kernel.org/patch/4729111/

	marc.info:

		http://marc.info/?l=linux-kernel&m=140812995414607&w=4
		http://marc.info/?l=linux-kernel&m=140812993814585&w=4

It looks like I reposted older versions by mistake on 31 July.
Very sorry :-(

The originals were changed as described here:

	http://marc.info/?l=linux-kernel&m=140621020918615
	http://marc.info/?l=linux-kernel&m=140618721010170

> 
> The following changes since commit 39b5a56ec0be5effe9b7d0f18cb27724bf2e5d47:
> 
>   Merge branch 'rfc/perf' into perf/core, because it's ready for inclusion (2014-08-24 22:35:42 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to fa3480cb0a96c8af9ded1a8c836c91bd5704bda1:
> 
>   perf tools: Add perf_pmu__scan_file() (2014-09-08 17:16:06 -0300)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> User visible:
> 
> o Add +field argument support for --sort option (Jiri Olsa)
> 
> Infrastructure:
> 
> o More intel PT prep work, from Adrian Hunter, including:
> 
>   - Let a user specify a PMU event without any config terms
>   - Add perf-with-kcore script
>   - Build programs to copy 32-bit compatibility VDSOs
>   - Add support for 32-bit compatibility VDSOs
>   - Let default config be defined for a PMU
>   - Add perf_pmu__scan_file()
> 
> o Add feature checks to .gitignore (Alexander Shishkin)
> 
> o "perf kvm stat report" improvements by Alexander Yarygin:
>   o  Save pid string in opts.target.pid
>   o  Enable the target.system_wide flag
>   o  Unify the title bar output
> 
> o Fix build issue on powerpc when DWARF support is disabled (Anton Blanchard)
> 
> o Allow to specify lib compile variable for spec usage (Jiri Olsa)
> 
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> ----------------------------------------------------------------
> Adrian Hunter (6):
>       perf tools: Let a user specify a PMU event without any config terms
>       perf tools: Add perf-with-kcore script
>       perf tools: Build programs to copy 32-bit compatibility VDSOs
>       perf tools: Add support for 32-bit compatibility VDSOs
>       perf tools: Let default config be defined for a PMU
>       perf tools: Add perf_pmu__scan_file()
> 
> Alexander Shishkin (1):
>       perf tools: Add feature checks to .gitignore
> 
> Alexander Yarygin (3):
>       perf kvm stat report: Save pid string in opts.target.pid
>       perf kvm stat report: Enable the target.system_wide flag
>       perf kvm stat report: Unify the title bar output
> 
> Anton Blanchard (1):
>       perf tools powerpc: Fix build issue when DWARF support is disabled
> 
> Jiri Olsa (2):
>       perf tools: Add +field argument support for --sort option
>       perf tools: Allow to specify lib compile variable for spec usage
> 
>  tools/perf/.gitignore            |   2 +
>  tools/perf/Makefile.perf         |  42 ++++++-
>  tools/perf/arch/powerpc/Makefile |   2 +-
>  tools/perf/builtin-kvm.c         |  23 ++--
>  tools/perf/config/Makefile       |  33 ++++-
>  tools/perf/config/Makefile.arch  |   8 ++
>  tools/perf/perf-read-vdso.c      |  59 +++++++++
>  tools/perf/perf-with-kcore.sh    | 259 +++++++++++++++++++++++++++++++++++++++
>  tools/perf/tests/pmu.c           |   2 +-
>  tools/perf/util/kvm-stat.h       |   1 -
>  tools/perf/util/parse-events.c   |  13 +-
>  tools/perf/util/parse-events.y   |  10 ++
>  tools/perf/util/pmu.c            |  79 +++++++++---
>  tools/perf/util/pmu.h            |  12 +-
>  tools/perf/util/sort.c           |  37 +++++-
>  tools/perf/util/vdso.c           | 170 ++++++++++++++++++++++++-
>  tools/perf/util/vdso.h           |   4 +-
>  17 files changed, 712 insertions(+), 44 deletions(-)
>  create mode 100644 tools/perf/perf-read-vdso.c
>  create mode 100644 tools/perf/perf-with-kcore.sh
> 
> 

