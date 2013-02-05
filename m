Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab3BEPgS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:36:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045Ab3BEPgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:36:15 -0500
Date: Tue, 5 Feb 2013 12:35:51 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH v7 00/18] perf: add memory access sampling support
Message-ID: <20130205153551.GC29163@infradead.org>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
 <20130125103832.GB20826@gmail.com>
 <CABPqkBQ8+wT1AYRNGttvteJTCujL4grQ20Pa6jnqrKKEvaVeWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBQ8+wT1AYRNGttvteJTCujL4grQ20Pa6jnqrKKEvaVeWA@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Feb 05, 2013 at 02:03:55PM +0100, Stephane Eranian escreveu:
> On Fri, Jan 25, 2013 at 11:38 AM, Ingo Molnar <mingo@kernel.org> wrote:
> > * Stephane Eranian <eranian@google.com> wrote:
> >> This patch series had a new feature to the kernel perf_events
> >> interface and corresponding user level tool, perf.

> > Ok, so I have created a topic tree for this, tip:perf/x86.

> > I have applied the kernel bits (with some minor renaming
> > changes). Arnaldo, if you agree with the tooling bits you can
> > merge that branch into your tree and apply the tooling bits from
> > Stephane.

> Arnaldo, did you incorporate the perf changes for this somewhere in
> your tree yet? The kernel bits are in.

I'm doing it, updating some csets on the go, will post here after I go
thru some tests.

- Arnaldo
