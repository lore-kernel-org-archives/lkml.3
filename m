Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbbAGNxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 08:53:46 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:42197 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbbAGNxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 08:53:44 -0500
Message-ID: <54AD3A68.1010602@linaro.org>
Date: Wed, 07 Jan 2015 13:53:44 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: kgdb-next not pushed to Linus for 3.19
References: <54AC2F5D.9050405@linaro.org>	<1420570662.2652.36.camel@perches.com> <20150106132102.65ad5988fc566357450e3d65@linux-foundation.org> <54AC6207.5000407@windriver.com>
In-Reply-To: <54AC6207.5000407@windriver.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/15 22:30, Jason Wessel wrote:
> On 01/06/2015 03:21 PM, Andrew Morton wrote:
>> On Tue, 06 Jan 2015 10:57:42 -0800 Joe Perches <joe@perches.com> wrote:
>>
>>> On Tue, 2015-01-06 at 18:54 +0000, Daniel Thompson wrote:
>>>> Hi Jason
>>>>
>>>> I'm trying to figure out what to do with my long-outstanding kgdb/kdb
>>>> patches in preparation for the 3.20 merge window.
>>>>
>>>> As of now I have five pending patch sets some of which are well over six
>>>> months old (and none have nay outstanding review comments).
>>>>
>>>> When I raised this with you a couple of months ago, two of the patch
>>>> sets did land in your kgdb-next tree. However nothing seems to have
>>>> happened since then and I couldn't find any messages from you during the
>>>> 3.19 merge window.
>>>>
>>>> I'm afraid I don't know what else I need to do to progress things.
>>>>
>>>> I do plan to do routine rebasing and resending of my patchsets but,
>>>> based on the past experience, that seems unlikely to be enough to get
>>>> the code delivered in 3.20.
>>>>
>>>> Do you think I would be better sending these patches via someone else?
>>>> In any case, advice would be very welcome.
>>> Andrew?
>>>
>>> I think Daniel's kgdb patches are bug fixes.
>>>
>>> Can you please pick them up?
>> yup.  Merging patches which are already in -next is a bit of a pain,
>> but I'll cope.
>>
>> Daniel, can you please resend everything in a nice clean coherent
>> stream?
>>
> 
> I did not mean to miss the merge window, but I ended up being out
> the majority of December -> yesterday.
> 
> Now that I am back, I don't think you have to burden Andrew here.
> I'll send a pull request for what is in kgdb-next since it is cleanups
> and fixes, and regression test anything else Daniel has left.

Ok.

I'm working on the rebase-and-resends now.


Thanks.
