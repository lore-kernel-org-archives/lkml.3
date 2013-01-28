Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3A1Wp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 17:45:59 -0500
Received: from mail-qe0-f49.google.com ([209.85.128.49]:35153 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab3A1Wp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 17:45:57 -0500
MIME-Version: 1.0
In-Reply-To: <20130128192151.GC15351@infradead.org>
References: <1358860732-4435-1-git-send-email-eranian@google.com>
	<1358860732-4435-3-git-send-email-eranian@google.com>
	<20130125025247.GA16249@infradead.org>
	<CABPqkBT-JuR=3q4X2o7Et9idd3T5Ut_GSnhpQKbqfr5SC4eDWA@mail.gmail.com>
	<20130128175938.GA15351@infradead.org>
	<CABPqkBS9yPGb3DOZv9qTULZrP+-8Zrbri99ZGBt7KopTfPWEfQ@mail.gmail.com>
	<20130128192151.GC15351@infradead.org>
Date: Mon, 28 Jan 2013 23:45:56 +0100
Message-ID: <CABPqkBQRZaErbJeJjcCZYzJOFe0WuAN3s5KYVojgTT8N3STKXg@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] perf stat: add interval printing
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 8:21 PM, Arnaldo Carvalho de Melo
<acme@redhat.com> wrote:
> Em Mon, Jan 28, 2013 at 07:26:17PM +0100, Stephane Eranian escreveu:
>> On Mon, Jan 28, 2013 at 6:59 PM, Arnaldo Carvalho de Melo
>> <acme@redhat.com> wrote:
>> > Em Fri, Jan 25, 2013 at 04:21:11PM +0100, Stephane Eranian escreveu:
>> >> On Fri, Jan 25, 2013 at 3:52 AM, Arnaldo Carvalho de Melo
>> >> <acme@redhat.com> wrote:
>> >> > Em Tue, Jan 22, 2013 at 02:18:52PM +0100, Stephane Eranian escreveu:
>> >> >> This patch adds a new printing mode for perf stat.
>> >> >> It allows internval printing. That means perf stat
>> >> >> can now print event deltas at regular time interval.
>> >> >> This is useful to detect phases in programs.
>> >> >
>> >> > This patch is not applying to my perf/core branch, does it depend on
>> >> > some other outstanding patchset from you?
>> >> >
>> >> > Tomorrow probably all I had in this area will be in Ingo's tree, but
>> >> > can you please take a look at my perf/core branch at:
>> >> >
>> >> > git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux
>> >> >
>> >> My patches are always relative to:
>> >> git://git.kernel.org/pub/scm/linux/kernel/git/tip.tip.git
>> >>
>> >> Do you still need to rebase against your tree?
>> >
>> > Well, userspace code normally is developed on my tree and eventually
>> > goes to the one you mentioned. If you make sure that now, that both are
>> > synched after some weeks, then probably it'll work with my tree.
>> >
>> How's the kernel proper side of your tree sync'd with tip.git? I cannot have
>> the kernel patches for one tree and the perf patches for another. That's a
>> lot of overhead especially when it comes to testing.
>
> Normally regularly, right now it seems all is synched.
>
Ok, will resubmit the series against your tree then.
