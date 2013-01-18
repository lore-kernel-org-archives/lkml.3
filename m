Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3ARAEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 19:04:49 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:41744 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab3ARAEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 19:04:47 -0500
MIME-Version: 1.0
In-Reply-To: <20130118000118.GC4051@tassilo.jf.intel.com>
References: <1358436287-22883-1-git-send-email-eranian@google.com>
	<20130118000118.GC4051@tassilo.jf.intel.com>
Date: Fri, 18 Jan 2013 01:04:46 +0100
Message-ID: <CABPqkBQthdLDrkiH-mg0Sq0w_satpscKgCau6K4hqSkwVkSNdg@mail.gmail.com>
Subject: Re: [PATCH 0/2] perf stat: add interval counter printing
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 1:01 AM, Andi Kleen <ak@linux.intel.com> wrote:
> On Thu, Jan 17, 2013 at 04:24:45PM +0100, Stephane Eranian wrote:
>> This small patchset extends perf stat with the -T option.
>
> I already use that option for my haswell patchkit for transactional
> monitoring.  Sorry, please use something else.
>
Fine. I'll find another single letter option.

> I agree it's a useful feature, although it can be simulated today.
>
You an simulate in system-wide, not clear for per-thread mode.

> -Andi
