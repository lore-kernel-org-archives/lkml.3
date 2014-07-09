Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281AbaGIPrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:47:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:26119 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbaGIPre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:47:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,631,1400050800"; 
   d="scan'208";a="455013648"
Date: Wed, 9 Jul 2014 08:47:18 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH v1 0/4] perf: add ability to sample interrupted machine
 state
Message-ID: <20140709154718.GA19781@tassilo.jf.intel.com>
References: <1404857759-25105-1-git-send-email-eranian@google.com>
 <87mwcj2b0z.fsf@sejong.aot.lge.com>
 <20140709145343.GA2384@redhat.com>
 <CABPqkBRO-p4Nv=2L9J19LgGdTmLTDBbMVf5kWFC8LzpKqax+Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRO-p4Nv=2L9J19LgGdTmLTDBbMVf5kWFC8LzpKqax+Yw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Value profiling means sampling the values of function arguments passed in
> registers.

You can use it for more, e.g. it's also useful to sample loop iterations.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
