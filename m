Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934318AbaKMVOO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 16:14:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:13912 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934123AbaKMVOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 16:14:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="416181442"
Date: Thu, 13 Nov 2014 13:14:07 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, namhyung@kernel.org
Subject: Re: [PATCH 10/10] tools, perf: Add asprintf replacement
Message-ID: <20141113211407.GA10824@tassilo.jf.intel.com>
References: <1415844328-4884-1-git-send-email-andi@firstfloor.org>
 <1415844328-4884-11-git-send-email-andi@firstfloor.org>
 <20141113205328.GC2578@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141113205328.GC2578@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
> > index fb272ff..493f011 100644
> > --- a/tools/perf/builtin-report.c
> > +++ b/tools/perf/builtin-report.c
> > @@ -762,6 +762,7 @@ repeat:
> >  	}
> >  	if (branch_call_mode) {
> >  		callchain_param.branch_callstack = 1;
> > +		callchain_param.key = CCKEY_ADDRESS;
> 
> unrelated hunk?

Yes. Please remove.

