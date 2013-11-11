Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3KKQHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:07:31 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:43970 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab3KKQHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:07:22 -0500
MIME-Version: 1.0
In-Reply-To: <20131111155905.GM19203@twins.programming.kicks-ass.net>
References: <1383939963-7750-1-git-send-email-eranian@google.com>
	<1383939963-7750-4-git-send-email-eranian@google.com>
	<20131111155905.GM19203@twins.programming.kicks-ass.net>
Date: Mon, 11 Nov 2013 17:07:22 +0100
Message-ID: <CABPqkBRZ84Hc9oAU6zFxNWMv9hT+zMu3Od7_b5fhHRgbG3MXPA@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] perf,x86: add Intel RAPL PMU support
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 4:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Nov 08, 2013 at 08:46:02PM +0100, Stephane Eranian wrote:
>
>
>> +static DEFINE_SPINLOCK(rapl_hotplug_lock);
>
> What is this thing protecting?
>
> Like last time it appears to be used only from hotplug notifier
> callbacks and those are already fully serialized.
>
I thought you or somebody else had said, that hotplug in now parallel.
