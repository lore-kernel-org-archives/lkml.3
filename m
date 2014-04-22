Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbaDVKHY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:07:24 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62444 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbaDVKHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:07:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAFrcx1n4VrLt7Vg2Rq73qkZ57DDTDN5uNLNLEQ1-Wt43X3SgTQ@mail.gmail.com>
References: <1396883078-25320-1-git-send-email-jean.pihet@linaro.org>
	<CAFrcx1=0TddfPS322728w3AsK5SzJ1sq-7VTbE=+Pb-EqcrncQ@mail.gmail.com>
	<20140417125030.GA4321@pd.tnic>
	<CAFrcx1noiierVs1tpkoqQ=L-Si0Xt5yVBvG3jgpi4hXepcabrg@mail.gmail.com>
	<20140417132157.GC4321@pd.tnic>
	<CAFrcx1n4VrLt7Vg2Rq73qkZ57DDTDN5uNLNLEQ1-Wt43X3SgTQ@mail.gmail.com>
Date: Tue, 22 Apr 2014 12:07:07 +0200
Message-ID: <CAFrcx1nL3Sc=vsxUwFqnoqgaFQcwbGROku8jpaxV0zUR0Hk-1g@mail.gmail.com>
Subject: Re: [PATCH v4 00/16] perf, persistent: Add persistent events
From: Jean Pihet <jean.pihet@linaro.org>
To: Borislav Petkov <bp@alien8.de>, Fu Wei <fu.wei@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Robert Richter <rric@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

-- adding Fu Wei in the loop--

Fu Wei is working on the RAS daemon, which is a user of libperf. It is
crucial to agree on the libperf API in order to start with the correct
implementation.

Jean

On 22 April 2014 10:20, Jean Pihet <jean.pihet@linaro.org> wrote:
> Hi Borislav,
>
> On 17 April 2014 15:21, Borislav Petkov <bp@alien8.de> wrote:
>> Hi Jean,
>>
>> On Thu, Apr 17, 2014 at 03:17:01PM +0200, Jean Pihet wrote:
>>> Yes indeed!
>>>
>>> Ingo,
>>> Is the perf support for persistent event needed, or can this series be
>>> reviewed as is?
>>>
>>> In the meantime I am now working on the perf tool:
>>> - add persistent events,
>>> - factor out the code and provide a library (libperf) for other tool
>>> to use it (e.g. monitoring daemon).
>>
>> Ok, good. I'm doing a bit too:
>>
>> https://lkml.org/lkml/2014/4/13/20
>>
>> so let's synchronize and get this thing going. I'll add you to my CC
>> list on future submissions.
> Ok, great!
>
> About libperf and the persistent events, do you know more details
> about the status and the proposed API? I have no info about the work
> that was started previously.
>
> Regards,
> Jean
>
>>
>> Thanks.
>>
>> --
>> Regards/Gruss,
>>     Boris.
>>
>> Sent from a fat crate under my desk. Formatting is fine.
>> --
