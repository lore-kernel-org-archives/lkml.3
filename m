Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab3K1M01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 07:26:27 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:60215 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab3K1M0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 07:26:23 -0500
Date: Thu, 28 Nov 2013 13:26:19 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Vince Weaver <vince@deater.net>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH v7 3/4] perf,x86: add Intel RAPL PMU support
Message-ID: <20131128122619.GA6561@gmail.com>
References: <1384275531-10892-1-git-send-email-eranian@google.com>
 <1384275531-10892-4-git-send-email-eranian@google.com>
 <alpine.DEB.2.02.1311271328590.22932@pianoman.cluster.toy>
 <CABPqkBScotKO03hTA6YNcD4sDVj_Gx1fjicmWOJh_MBYTF+rfQ@mail.gmail.com>
 <alpine.DEB.2.02.1311271653280.24499@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311271653280.24499@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vince Weaver <vince@deater.net> wrote:

> On Wed, 27 Nov 2013, Stephane Eranian wrote:
> 
> > On Wed, Nov 27, 2013 at 7:35 PM, Vince Weaver <vince@deater.net> wrote:
> 
> > > So I notice PP1 (which is the GPU power on non-server chips)
> > > is not supported.
> > >
> > > Is that just for simplicity?
> > >
> > Does it work on specific models only? I bet so. How to detect those?
> 
> In general it is on the machines that don't support the DRAM measurements 
> (so the non-EP machines) but I don't know if there's a nice list anywhere.
> 
> Intel manuals say:
>    For a client platform, PP1 domain refers to the power plane of a 
>    specific device in the uncore. For server platforms, PP1 domain is not
>    supported,
> 
> usually PP1 I think maps to the embedded GPU.

It would indeed be nice to expose PP1 too via the same facility - 
Haswell and later spends some 40% of the CPU die on the integrated GPU 
and people end up using it.

Thanks,

	Ingo
