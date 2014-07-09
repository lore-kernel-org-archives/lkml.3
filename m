Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbaGIPwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:52:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:5720 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756271AbaGIPwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:52:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,631,1400050800"; 
   d="scan'208";a="540946477"
Date: Wed, 9 Jul 2014 08:45:10 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        jolsa@redhat.com, acme@redhat.com, namhyung@kernel.org
Subject: Re: [PATCH 4/4] perf record: add new -I option to sample interrupted
 machine state
Message-ID: <20140709154510.GY19781@tassilo.jf.intel.com>
References: <1404857759-25105-1-git-send-email-eranian@google.com>
 <1404857759-25105-5-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404857759-25105-5-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 12:15:59AM +0200, Stephane Eranian wrote:
> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
> index 378b85b..17c45f8 100644
> --- a/tools/perf/builtin-record.c
> +++ b/tools/perf/builtin-record.c
> @@ -876,6 +876,8 @@ const struct option record_options[] = {
>  		    "sample transaction flags (special events only)"),
>  	OPT_BOOLEAN(0, "per-thread", &record.opts.target.per_thread,
>  		    "use per-thread mmaps"),
> +	OPT_BOOLEAN('I', "sample-intr-regs", &record.opts.sample_intr_regs,

Long option is too long. --user-regs or so?

-Andi
