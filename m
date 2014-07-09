Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964811AbaGIP01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 11:26:27 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:46422 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932729AbaGIP0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 11:26:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140709145343.GA2384@redhat.com>
References: <1404857759-25105-1-git-send-email-eranian@google.com>
	<87mwcj2b0z.fsf@sejong.aot.lge.com>
	<20140709145343.GA2384@redhat.com>
Date: Wed, 9 Jul 2014 17:26:22 +0200
Message-ID: <CABPqkBRO-p4Nv=2L9J19LgGdTmLTDBbMVf5kWFC8LzpKqax+Yw@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] perf: add ability to sample interrupted machine state
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 4:53 PM, Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
> Em Wed, Jul 09, 2014 at 05:26:20PM +0900, Namhyung Kim escreveu:
>> On Wed,  9 Jul 2014 00:15:55 +0200, Stephane Eranian wrote:
>> > This patch series is the fundation for a future series adding
>> > function value profiling.
>>
>> Probably a silly question: what is the function value profiling?
>
> I think he wants to sample the values of parameters and local variables,
> etc, right?
>
> http://lists.cs.uiuc.edu/pipermail/llvmdev/2013-June/062950.html lists
> some things you can do with that.
>
> Stephane, is that what you mean by "value profiling"?
>
Value profiling means sampling the values of function arguments passed in
registers.
