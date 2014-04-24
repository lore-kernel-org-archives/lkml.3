Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317AbaDXQRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:17:05 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1661 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753250AbaDXQRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:17:02 -0400
Message-ID: <535938F8.3070300@nod.at>
Date: Thu, 24 Apr 2014 18:16:56 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ley Foon Tan <lftan@altera.com>
CC: Linux-Arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        cltang@codesourcery.com
Subject: Re: [PATCH 17/28] nios2: Signal handling support
References: <1397824031-4892-1-git-send-email-lftan@altera.com>	<1397824031-4892-14-git-send-email-lftan@altera.com>	<CAFLxGvyPCwo-d92QK9qAR5=gmRS4p24tYs9PiOApBGfrKdxJ5Q@mail.gmail.com>	<CAFiDJ5-q5hzR+1BDCmCzwqbuVZOUdjX_-omR4u3rnC8xqdQZLA@mail.gmail.com>	<CAFiDJ59g0E+hoREriydqk2uBsDvchPMSQi6NCgnwOd64OGLJ0w@mail.gmail.com>	<5358E4B9.1050308@nod.at>	<CAFiDJ5_pbcQo7VPj6J9UVhxGQtGn7hX19vkybL3DvM73v8Dc-w@mail.gmail.com>	<5358E9EB.8080307@nod.at> <CAFiDJ59hHikNKcY8hCu9M=hOQoL9STED82hEhAggubq3jqt3ig@mail.gmail.com>
In-Reply-To: <CAFiDJ59hHikNKcY8hCu9M=hOQoL9STED82hEhAggubq3jqt3ig@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.04.2014 12:46, schrieb Ley Foon Tan:
> On Thu, Apr 24, 2014 at 6:39 PM, Richard Weinberger <richard@nod.at> wrote:
>> Am 24.04.2014 12:29, schrieb Ley Foon Tan:
>>> On Thu, Apr 24, 2014 at 6:17 PM, Richard Weinberger <richard@nod.at> wrote:
>>>
>>>>>> Okay.
>>>>>>
>>>>> I just noticed that sigsp() have struct ksignal argument. We can use
>>>>> sigsp() for nios2 because it doesn't have struct ksignal.
>>>>>
>>>>> unsigned long sigsp(unsigned long sp, struct ksignal *ksig);
>>>>
>>>> Did you at look at the struct ksignal definition and the clean series I've
>>>> pointed you to?
>>>>
>>>
>>> Not yet, this is the full set of patches? I only see partial..
>>> https://lkml.org/lkml/2014/3/2/198
>>
>> Maybe lkml.org misses a few but this does not matter.
>> All you need to know is that using ksignal is easy.
>> e.g. https://lkml.org/lkml/2014/3/2/162
>>
> Thanks. I am looking at your git tree
> https://git.kernel.org/cgit/linux/kernel/git/rw/misc.git/log/?h=signal_v2
> Are these patches already available in v3.15 rc?

Nope, I have to rebase them again.
But some archs have picked up the changes already.

> I can update nios2 to use new implementation.

Would be great. :)

Thanks,
//richard
