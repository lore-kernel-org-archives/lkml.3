Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbbAEP65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:58:57 -0500
Received: from mga03.intel.com ([134.134.136.65]:34288 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbbAEP6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:58:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="436649347"
From: "Liang, Kan" <kan.liang@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Jiri Olsa <jolsa@redhat.com>, "acme@kernel.org" <acme@kernel.org>,
        "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>
Subject: RE: [PATCH V5 0/3] perf tool: Haswell LBR call stack support (user)
Thread-Topic: [PATCH V5 0/3] perf tool: Haswell LBR call stack support (user)
Thread-Index: AQHQDkRfJnDNoBLJ7kWTuaSxvb8h+5x++RsAgDLJ0CqAAB7RIA==
Date: Mon, 5 Jan 2015 15:58:46 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F07701692D68@SHSMSX103.ccr.corp.intel.com>
References: <1417532814-26208-1-git-send-email-kan.liang@intel.com>
 <20141204142330.GB10406@krava.brq.redhat.com>
 <37D7C6CF3E00A74B8858931C1DB2F0770167D124@shsmsx102.ccr.corp.intel.com>
 <20150105135748.GT30905@twins.programming.kicks-ass.net>
In-Reply-To: <20150105135748.GT30905@twins.programming.kicks-ass.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> On Thu, Dec 04, 2014 at 02:49:52PM +0000, Liang, Kan wrote:
> > > I'll test it once I get hands on Haswel server again, I guess we
> > > wait for the kernel change to go in first anyway, right?
> > >
> >
> > I'm not sure, let's ask Peter.
> >
> > Peter?
> 
> Ok so only 3/3 was missing right? I handed the kernel bits to Ingo when I
> 'left' with a note that userspace was pending. It seems that is now resolved.
> 
> I stuck 3/3 at the end (it seems to still apply -- yay!) and will send it
> together with the kernel bits.

Besides 3/3, we still need part of 1/3. Because we only have part of 1/3 merged.
I will re-send the userspace soon.

Thanks,
Kan

