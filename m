Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab3BTWIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:08:06 -0500
Received: from mga14.intel.com ([143.182.124.37]:13525 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab3BTWIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:08:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,703,1355126400"; 
   d="scan'208";a="259517487"
Date: Wed, 20 Feb 2013 14:08:02 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] perf, x86: add Intel IvyBridge event scheduling
 constraints
Message-ID: <20130220220802.GE23293@tassilo.jf.intel.com>
References: <1361355312-3323-1-git-send-email-eranian@google.com>
 <20130220154344.GD23293@tassilo.jf.intel.com>
 <CABPqkBS58oMw8Gs7AVN0OMvLuFYH4iXXRHBx3Ep1Mbru=gLVtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBS58oMw8Gs7AVN0OMvLuFYH4iXXRHBx3Ep1Mbru=gLVtg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Except for LDM_PENDING the CYCLE_ACTIVITY events have been also added to Sandy Bridge.
> > So it should be also added there.
> >
> As far as I know and I double-checked the documentation I have, there
> is no CYCLE_ACTIVITY
> event on SNB or SNB-EP.

page 19-28 in the Jan 2013 SDM. It was only recently added.
It's only a subset of what you have on Ivy Bridge.

> 
> > In fact I think you can still share the table because it would just add some
> > non existent events to Sandy Bridge, which is a noop.
> >
> I don't see the point of this, except saving a few bytes. Isn't it
> better to keep each PMU separate?

Ok, as long as you update the SNB table too.

-Andi
