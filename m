Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbaJ2JL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:11:57 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64994 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbaJ2JLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:11:53 -0400
Date: Wed, 29 Oct 2014 10:11:48 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Andi Kleen <ak@linux.intel.com>, Anton Blanchard <anton@au1.ibm.com>,
        Arun Sharma <asharma@fb.com>, Borislav Petkov <bp@suse.de>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Waiman Long <Waiman.Long@hp.com>, Wang Nan <wangnan0@huawei.com>
Subject: Re: [GIT PULL 00/32] perf/core improvements and fixes
Message-ID: <20141029091148.GA9000@gmail.com>
References: <1414503146-22789-1-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414503146-22789-1-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@kernel.org> wrote:

> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> Hi Ingo,
> 
> 	Please consider pulling,
> 
> - Arnaldo
> 
> The following changes since commit e53f6124af6516cee3063a3072767ee2717ff343:
> 
>   Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent (2014-10-24 09:46:36 +0200)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tags/perf-core-for-mingo
> 
> for you to fetch changes up to 8eeeb304ea2714962b10873f72aa7c5e24f5265f:
> 
>   perf probe: Add --quiet option to suppress output result message (2014-10-27 17:16:34 -0200)
> 
> ----------------------------------------------------------------
> perf/core improvements and fixes:
> 
> User visible:
> 
> * 'perf probe' --demangle typo fix and a new --quiet option (Masami Hiramatsu)

So the fix part would be nice to have for perf/urgent I suspect?

> * Fix report -F (abort, in_tx, mispredict, etc) segfaults for sample.data files
>   without branch info (Jiri Olsa)

Ditto.

> * Don't open the DWARF info multiple times, keeping instead a dwfl handle
>   in struct dso, greatly speeding up 'perf report' on powerpc. (Sukadev Bhattiprolu)
> 
> * Add patch that should have went in a previous patchkit to use global cache
>   provided by libunwind (Namhyung Kim)

Given that this is already upstream, is this a required fix for 
perf/urgent or can it wait and go into perf/core?

And then the remaining bits should be based on the urgent tree.

Thanks,

	Ingo
