Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933497Ab3BLR3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:29:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:35561 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932348Ab3BLR3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:29:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="290162340"
Date: Tue, 12 Feb 2013 09:29:51 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 0/2] perf stat: add per-core count aggregation
Message-ID: <20130212172951.GD30387@tassilo.jf.intel.com>
References: <1360678168-6974-1-git-send-email-eranian@google.com>
 <20130212172319.GB30387@tassilo.jf.intel.com>
 <CABPqkBTZ+ooWHFvagR=YFDUdnnW9az0LXg1-etNfgC2Af8yA-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTZ+ooWHFvagR=YFDUdnnW9az0LXg1-etNfgC2Af8yA-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > The idea itself is useful.
> >
> Yes, it is.

BTW it would be even more useful if it could print some of the
statistics turbostat does (in particular frequency and C0 residency)
Often you only care about cycles not idle, and the frequency
tells you how fast the cycles happen.

I think Cx could be added relatively easily as a software event,
but frequency doesn't fit very well into the perf counting model,
as it's really sampling.

-Andi
