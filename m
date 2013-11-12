Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab3KLPCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 10:02:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:16573 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab3KLPCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 10:02:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="433939025"
Date: Tue, 12 Nov 2013 07:02:00 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH v6 3/4] perf,x86: add Intel RAPL PMU support
Message-ID: <20131112150200.GB3499@tassilo.jf.intel.com>
References: <1383939963-7750-1-git-send-email-eranian@google.com>
 <1383939963-7750-4-git-send-email-eranian@google.com>
 <20131111155905.GM19203@twins.programming.kicks-ass.net>
 <CABPqkBRZ84Hc9oAU6zFxNWMv9hT+zMu3Od7_b5fhHRgbG3MXPA@mail.gmail.com>
 <20131111161631.GA21461@twins.programming.kicks-ass.net>
 <CABPqkBQB-35ZN_w2HNgFyWwnKaBWnCtpbxFOgMW2PKZxsdgPQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQB-35ZN_w2HNgFyWwnKaBWnCtpbxFOgMW2PKZxsdgPQw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't know where Andi got that cpu starting was parallel now.
> Andi?

I know there was some work on it, but maybe it hasn't been merged yet.

> 
> If hotplug is not parallel, then we can drop that RAPL hotplug_lock
> I added.

I guess your patch is ok without lock for now, sorry for the objection.

-Andi
