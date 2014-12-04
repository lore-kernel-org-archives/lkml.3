Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698AbaLDQXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:23:06 -0500
Received: from mga03.intel.com ([134.134.136.65]:29977 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482AbaLDQXD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:23:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,516,1413270000"; 
   d="scan'208";a="618643408"
From: "Liang, Kan" <kan.liang@intel.com>
To: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: "eranian@google.com" <eranian@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "namhyung@kernel.org" <namhyung@kernel.org>
Subject: RE: [PATCH V5 0/3] perf tool: Haswell LBR call stack support (user)
Thread-Topic: [PATCH V5 0/3] perf tool: Haswell LBR call stack support (user)
Thread-Index: AQHQDkRfJnDNoBLJ7kWTuaSxvb8h+5x++RsAgACMFfD//4yQAIAAAvCAgACI3PA=
Date: Thu, 4 Dec 2014 16:18:56 +0000
Message-ID: <37D7C6CF3E00A74B8858931C1DB2F0770167E1F0@shsmsx102.ccr.corp.intel.com>
References: <1417532814-26208-1-git-send-email-kan.liang@intel.com>
 <20141204142330.GB10406@krava.brq.redhat.com>
 <37D7C6CF3E00A74B8858931C1DB2F0770167D124@shsmsx102.ccr.corp.intel.com>
 <20141204155142.GD18689@kernel.org>
 <20141204160213.GB18631@krava.brq.redhat.com>
In-Reply-To: <20141204160213.GB18631@krava.brq.redhat.com>
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
> On Thu, Dec 04, 2014 at 12:51:42PM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Dec 04, 2014 at 02:49:52PM +0000, Liang, Kan escreveu:
> > > Jiri Wrote:
> > > > looks ok to me..
> >
> > > Thanks for the review.
> >
> > > > I'll test it once I get hands on Haswel server again, I guess we
> > > > wait for the kernel change to go in first anyway, right?
> >
> > > I'm not sure, let's ask Peter.
> >
> > > Peter?
> >
> > Would be good to go in one pull request, so that whoever pulls it has
> > the chance to test the kernel feature with the accompanying tooling bits.
> 
> also there's user part dependency on kernel.. soem new define IIRC
> 

Oh, right. We have to let them go in together.

Hi Peter,

I have verified that the V8 kernel part patch is compatible with both latest
tip and latest perf/core. We don't need to rebase.
The user perf tool for tip is not updated yet. We need to merge latest
perf/core to tip before applying user part patch.

Do you have more comments for the code?

The latest kernel and user part codes are here.
https://lkml.org/lkml/2014/11/6/432
https://lkml.org/lkml/2014/12/2/396

Thanks,
Kan
