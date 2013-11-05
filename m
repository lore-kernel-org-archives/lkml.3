Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab3KEPDt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 10:03:49 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:62786 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab3KEPDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 10:03:48 -0500
MIME-Version: 1.0
In-Reply-To: <CABPqkBQam9u-jZkvdV6P=n7ZGas6Rbt+EL=2UUOT86RteXkO_g@mail.gmail.com>
References: <1383231582-15856-1-git-send-email-eranian@google.com>
	<1383231582-15856-3-git-send-email-eranian@google.com>
	<20131101105722.GA1088@krava.brq.redhat.com>
	<CABPqkBRXPYHNmCbcGDvqSNxY_zWfUiy3S3_9SasrVw9nbNL9Mg@mail.gmail.com>
	<20131104145110.GA2805@krava.brq.redhat.com>
	<CABPqkBQ1Kv9MMBhRdNoBA4k=n=cGVQtuUn810P7-PSu_SRwLug@mail.gmail.com>
	<20131105141613.GD1962@tassilo.jf.intel.com>
	<CABPqkBQam9u-jZkvdV6P=n7ZGas6Rbt+EL=2UUOT86RteXkO_g@mail.gmail.com>
Date: Tue, 5 Nov 2013 16:03:47 +0100
Message-ID: <CABPqkBTzRt8XaAEhfqmazxoWJSNoD5cLL=ze0SjDY=cqCs0tbw@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] perf stat: add event unit and scale support
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Yan, Zheng" <zheng.z.yan@intel.com>, Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 5, 2013 at 3:17 PM, Stephane Eranian <eranian@google.com> wrote:
> On Tue, Nov 5, 2013 at 3:16 PM, Andi Kleen <ak@linux.intel.com> wrote:
>>> Any opinion?
>>
>> Just don't show the unit if there is no unit.
>> That is what I asked for earlier.
>>
> You said, print ? if no unit.

Okay, I now print nothing when there is no unit. Fixed up a couple of
printf alignment issues.
It's all good now. Posting the series momentarily.
