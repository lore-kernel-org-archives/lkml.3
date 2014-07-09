Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696AbaGIROP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 13:14:15 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:57680 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556AbaGIROL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 13:14:11 -0400
MIME-Version: 1.0
In-Reply-To: <20140709154718.GA19781@tassilo.jf.intel.com>
References: <1404857759-25105-1-git-send-email-eranian@google.com>
	<87mwcj2b0z.fsf@sejong.aot.lge.com>
	<20140709145343.GA2384@redhat.com>
	<CABPqkBRO-p4Nv=2L9J19LgGdTmLTDBbMVf5kWFC8LzpKqax+Yw@mail.gmail.com>
	<20140709154718.GA19781@tassilo.jf.intel.com>
Date: Wed, 9 Jul 2014 19:14:10 +0200
Message-ID: <CABPqkBQUm9C=NkYCCJRH+rf5HUmZecg1UQyZknic6D+tT-hbxQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] perf: add ability to sample interrupted machine state
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 9, 2014 at 5:47 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> Value profiling means sampling the values of function arguments passed in
>> registers.
>
> You can use it for more, e.g. it's also useful to sample loop iterations.
>
Correct.

> -Andi
>
> --
> ak@linux.intel.com -- Speaking for myself only
