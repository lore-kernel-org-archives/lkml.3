Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125Ab3HNQhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:37:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760024Ab3HNQhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:37:53 -0400
Date: Wed, 14 Aug 2013 18:36:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH V11 12/15] perf tools: add missing 'abi' member to
 'struct regs_dump'
Message-ID: <20130814163625.GA1017@krava.brq.redhat.com>
References: <1376484517-5339-1-git-send-email-adrian.hunter@intel.com>
 <1376484517-5339-13-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376484517-5339-13-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 03:48:34PM +0300, Adrian Hunter wrote:
> And store the parsed value there.  Note that the 'abi' is
> 0 (no registers), 1 (32-bit registers) or 2 (64-bit registers),
> but the registers are anyway copied one-by-one as 64-bit
> values onto the event i.e. see 'perf_output_sample_regs()'
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>
