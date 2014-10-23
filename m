Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754713AbaJWXn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 19:43:58 -0400
Received: from mail.kernel.org ([198.145.19.201]:56626 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbaJWXn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 19:43:57 -0400
Date: Thu, 23 Oct 2014 20:43:52 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 00/16] perf tools: Intel PT preparation continued
Message-ID: <20141023234352.GS14687@kernel.org>
References: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414061124-26830-1-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 23, 2014 at 01:45:08PM +0300, Adrian Hunter escreveu:
> Adrian Hunter (16):

Applied these, will test those and put in my next pull req to Ingo:

>       perf pmu: Let pmu's with no events show up on perf list
>       perf tools: Build programs to copy 32-bit compatibility VDSOs
>       perf tools: Add support for 32-bit compatibility VDSOs
>       perf tools: Do not attempt to run perf-read-vdso32 if it wasn't built

The next two are related, made questions about the first:

>       perf tools: Add id index
>       perf session: Add perf_session__deliver_synth_event()

Made some questions about these two as well:

>       perf tools: Add a thread stack for synthesizing call chains
>       perf tools: Enhance the thread stack to output call/return data

These all are about the db_export, if time permits tomorrow I'll try to
do what I suggested and post a patch for you to see, i.e. basically the
first one is the one with the questions.

>       perf tools: Add facility to export data in database-friendly way
>       perf tools: Extend Python script interface to export data in a database-friendly way
>       perf tools: Add Python script to export to postgresql
>       perf tools: Add branch type to db export
>       perf tools: Add branch_type and in_tx to Python export
>       perf tools: Add call information to the database export API
>       perf tools: Add call information to Python export
>       perf tools: Defer export of comms that were not 'set'


- Arnaldo
