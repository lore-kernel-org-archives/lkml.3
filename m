Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab3FXIQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 04:16:28 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:53632 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab3FXIQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 04:16:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130623215854.GB995@krava.redhat.com>
References: <1371824448-7306-1-git-send-email-eranian@google.com>
	<20130623215854.GB995@krava.redhat.com>
Date: Mon, 24 Jun 2013 10:16:23 +0200
Message-ID: <CABPqkBSAYr4O-4-13Jh8S7Uub1hfFK0cJGJXd2JeUE7_jqmGFQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] perf: add ability to sample physical data addresses
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It applies and compiles for me on tip.git:

4ce9207 Merge branch 'x86/platform'


On Sun, Jun 23, 2013 at 11:58 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Fri, Jun 21, 2013 at 04:20:40PM +0200, Stephane Eranian wrote:
>> This patch series extends perf_events with the ability to sample
>> physical data addresses. This is useful with the memory access
>> sampling mode added just recently. In particular, it helps
>> disambiguate data addresses between two processes, such as
>> in the case of a shared memory segment mapped at different
>> addresses in different processes.
>
> hi,
> what is this patchset based on?
> I cannot apply this on tip nor on acme's tree.
>
> thanks,
> jirka
