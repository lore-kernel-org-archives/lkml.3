Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab3BFNYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 08:24:33 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:60916 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab3BFNYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 08:24:32 -0500
Date: Wed, 6 Feb 2013 14:24:27 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v7 00/18] perf: add memory access sampling support
Message-ID: <20130206132427.GB15280@gmail.com>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
 <20130125103832.GB20826@gmail.com>
 <CABPqkBQ8+wT1AYRNGttvteJTCujL4grQ20Pa6jnqrKKEvaVeWA@mail.gmail.com>
 <20130205153551.GC29163@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130205153551.GC29163@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Em Tue, Feb 05, 2013 at 02:03:55PM +0100, Stephane Eranian escreveu:
> > On Fri, Jan 25, 2013 at 11:38 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > > * Stephane Eranian <eranian@google.com> wrote:
> > >> This patch series had a new feature to the kernel perf_events
> > >> interface and corresponding user level tool, perf.
> 
> > > Ok, so I have created a topic tree for this, tip:perf/x86.
> 
> > > I have applied the kernel bits (with some minor renaming
> > > changes). Arnaldo, if you agree with the tooling bits you can
> > > merge that branch into your tree and apply the tooling bits from
> > > Stephane.
> 
> > Arnaldo, did you incorporate the perf changes for this somewhere in
> > your tree yet? The kernel bits are in.
> 
> I'm doing it, updating some csets on the go, will post here 
> after I go thru some tests.

Great. Please pull/merge tip:perf/x86 directly before you apply 
and test the tooling bits - right now it's not in tip:master nor 
in perf/core. That way it will be in the tree as a coherent 
unit.

Thanks,

	Ingo
