Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbaCROSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:18:47 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:52683 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919AbaCROSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:18:45 -0400
MIME-Version: 1.0
In-Reply-To: <CALkWK0mODh_R9p10q2VPcJK4qnmNuJfQJm5wv2Rr=+cn+X-LDQ@mail.gmail.com>
References: <1395095198-20034-1-git-send-email-artagnon@gmail.com>
 <1395095198-20034-3-git-send-email-artagnon@gmail.com> <87ha6wrl8h.fsf@sejong.aot.lge.com>
 <CALkWK0mODh_R9p10q2VPcJK4qnmNuJfQJm5wv2Rr=+cn+X-LDQ@mail.gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Tue, 18 Mar 2014 23:18:24 +0900
X-Google-Sender-Auth: TZwn_ZKPFfvvXNDRNxNx3HRjk-A
Message-ID: <CAM9d7ciC4RF_12cVxnJ-yLcwkHQf-bT+h38-imCib1UgHxsa=g@mail.gmail.com>
Subject: Re: [PATCH 2/5] tools lib traceevent: handle the '->' operator
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ramkumar,

On Tue, Mar 18, 2014 at 11:12 PM, Ramkumar Ramachandra
<artagnon@gmail.com> wrote:
> Hi Namhyung,
>
> On Tue, Mar 18, 2014 at 3:58 AM, Namhyung Kim <namhyung@kernel.org> wrote:
>> Hmm.. AFAIK we don't support the '->' operator so I think it's an error
>> in the callsite.  Where do you see the message though?  I couldn't find
>> it on my setup.
>>
>> I'd also like to add following patch to see the location of parse
>> failure easily.
>
> I applied your patch and ran 'perf test'. I get:
>
>   Warning: [i915:i915_gem_evict_vm] unknown op '->'
>
> So, where should we dig to find this callsite?

/sys/kernel/debug/tracing/events/i915/i915_gen_evict_vm/format :)


Thanks,
Namhyung
