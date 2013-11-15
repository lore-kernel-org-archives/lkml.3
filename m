Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab3KOMaa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 07:30:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51099 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3KOMaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 07:30:22 -0500
Date: Fri, 15 Nov 2013 13:30:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH 10/10] perf record: Add an option to force per-cpu mmaps
Message-ID: <20131115123013.GF10456@twins.programming.kicks-ass.net>
References: <1384460715-23198-1-git-send-email-acme@infradead.org>
 <1384460715-23198-11-git-send-email-acme@infradead.org>
 <20131115060643.GA9237@gmail.com>
 <5285FECE.7020802@intel.com>
 <20131115111032.GA18647@gmail.com>
 <52860529.50200@intel.com>
 <20131115115629.GB19004@gmail.com>
 <20131115120329.GH2965@twins.programming.kicks-ass.net>
 <20131115120525.GA20855@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115120525.GA20855@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 01:05:25PM +0100, Ingo Molnar wrote:
> Do the first variant, 'perf record <cmd>', already use per CPU 
> buffers?

Yes.. this is required for inheritance to work.
