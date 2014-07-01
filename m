Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbaGASUk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:20:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:39306 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755032AbaGASUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:20:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,583,1400050800"; 
   d="scan'208";a="452188844"
Date: Tue, 1 Jul 2014 11:20:17 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Joe Mario <jmario@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH v2 1/2] perf/x86: simplify PEBS constraints
Message-ID: <20140701182017.GL19781@tassilo.jf.intel.com>
References: <1403876883-3059-1-git-send-email-eranian@google.com>
 <1403876883-3059-2-git-send-email-eranian@google.com>
 <20140627153744.GB19781@tassilo.jf.intel.com>
 <CABPqkBSYwTFDzWkNO13TyoozW6vWw-ukp9uLdRzrK0Prn44F3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBSYwTFDzWkNO13TyoozW6vWw-ukp9uLdRzrK0Prn44F3w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Stephane,

Please review the followon patch I sent later. This version had some issues
as you noticed.

> > his patchkit.
> >
> It is missing NHM, WSM, Atom, mine did cover that.

True. I guess we could just use yours for that.

> > I only did Sandy Bridge and Silvermont and later so far, mostly because these
> > are the parts I could directly confirm the hardware behavior with hardware
> > architects.
> >
> The patch does not work as expected, unfortunately. See below.

See the other patch.

-Andi
