Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab3BEND6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 08:03:58 -0500
Received: from mail-qe0-f43.google.com ([209.85.128.43]:47448 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754785Ab3BEND4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 08:03:56 -0500
MIME-Version: 1.0
In-Reply-To: <20130125103832.GB20826@gmail.com>
References: <1359040242-8269-1-git-send-email-eranian@google.com>
	<20130125103832.GB20826@gmail.com>
Date: Tue, 5 Feb 2013 14:03:55 +0100
Message-ID: <CABPqkBQ8+wT1AYRNGttvteJTCujL4grQ20Pa6jnqrKKEvaVeWA@mail.gmail.com>
Subject: Re: [PATCH v7 00/18] perf: add memory access sampling support
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 11:38 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> This patch series had a new feature to the kernel perf_events
>> interface and corresponding user level tool, perf.
>
> Ok, so I have created a topic tree for this, tip:perf/x86.
>
> I have applied the kernel bits (with some minor renaming
> changes). Arnaldo, if you agree with the tooling bits you can
> merge that branch into your tree and apply the tooling bits from
> Stephane.
>
Arnaldo, did you incorporate the perf changes for this somewhere in
your tree yet? The kernel bits are in.
