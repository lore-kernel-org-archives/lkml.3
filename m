Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbaGKPgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:36:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:41620 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbaGKPga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:36:30 -0400
Date: Fri, 11 Jul 2014 17:36:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: acme@kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        "Shishkin, Alexander" <alexander.shishkin@intel.com>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: perf tools: Call graph from Intel BTS
Message-ID: <20140711153626.GP20603@laptop.programming.kicks-ass.net>
References: <53BFF679.2030006@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BFF679.2030006@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 05:36:41PM +0300, Adrian Hunter wrote:
> Hi
> 
> Alexander Shishkin is working on the Intel PT driver for perf
> and has included a driver for Intel BTS.  I have taken that and

There is already a BTS driver, although I've not used it ever, since
there's no useful tool for it. One way would be to use that, and migrate
to PT data later.
