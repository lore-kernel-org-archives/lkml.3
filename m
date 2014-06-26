Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbaFZHjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 03:39:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061AbaFZHjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 03:39:17 -0400
Date: Thu, 26 Jun 2014 09:38:02 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <rric@kernel.org>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Jean Pihet <jean.pihet@linaro.org>
Subject: Re: [PATCH] perf tool: Carve out ctype.h et al
Message-ID: <20140626073802.GC1177@krava.brq.redhat.com>
References: <1403688184-6917-1-git-send-email-bp@alien8.de>
 <20140625192547.GF1153@krava.brq.redhat.com>
 <20140625203836.GD13845@pd.tnic>
 <20140625211757.GD18773@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140625211757.GD18773@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 06:17:57PM -0300, Arnaldo Carvalho de Melo wrote:

SNIP

> > 
> >     Merge remote-tracking branch 'jolsa/perf/urgent' into ptool-v0.5
> > 
> > commit a93f0e551af9e194db38bfe16001e17a3a1d189a
> > Author: Simon Que <sque@chromium.org>
> > Date:   Mon Jun 16 11:32:09 2014 -0700
> > 
> >     perf symbols: Get kernel start address by symbol name
> > 
> > by checking out acme/perf/core first.
> > 
> > So, guys, can we agree on a common branch to apply patches ontop please?
> 
> I'd say work on tip/perf/core, if it doesn't apply on mine or jolsa's,
> we'll fix it up, right Jiri?

yep, tip/perf/core maybe plus merges from acme/perf/core and jolsa/perf/core
should do it ;-)

jirka
