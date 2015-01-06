Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125AbbAFWav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 17:30:51 -0500
Received: from mail1.windriver.com ([147.11.146.13]:52539 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbbAFWau convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 17:30:50 -0500
Message-ID: <54AC6207.5000407@windriver.com>
Date: Tue, 6 Jan 2015 16:30:31 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>
CC: Daniel Thompson <daniel.thompson@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        Ingo Molnar <mingo@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: kgdb-next not pushed to Linus for 3.19
References: <54AC2F5D.9050405@linaro.org>	<1420570662.2652.36.camel@perches.com> <20150106132102.65ad5988fc566357450e3d65@linux-foundation.org>
In-Reply-To: <20150106132102.65ad5988fc566357450e3d65@linux-foundation.org>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2015 03:21 PM, Andrew Morton wrote:
> On Tue, 06 Jan 2015 10:57:42 -0800 Joe Perches <joe@perches.com> wrote:
>
>> On Tue, 2015-01-06 at 18:54 +0000, Daniel Thompson wrote:
>>> Hi Jason
>>>
>>> I'm trying to figure out what to do with my long-outstanding kgdb/kdb
>>> patches in preparation for the 3.20 merge window.
>>>
>>> As of now I have five pending patch sets some of which are well over six
>>> months old (and none have nay outstanding review comments).
>>>
>>> When I raised this with you a couple of months ago, two of the patch
>>> sets did land in your kgdb-next tree. However nothing seems to have
>>> happened since then and I couldn't find any messages from you during the
>>> 3.19 merge window.
>>>
>>> I'm afraid I don't know what else I need to do to progress things.
>>>
>>> I do plan to do routine rebasing and resending of my patchsets but,
>>> based on the past experience, that seems unlikely to be enough to get
>>> the code delivered in 3.20.
>>>
>>> Do you think I would be better sending these patches via someone else?
>>> In any case, advice would be very welcome.
>> Andrew?
>>
>> I think Daniel's kgdb patches are bug fixes.
>>
>> Can you please pick them up?
> yup.  Merging patches which are already in -next is a bit of a pain,
> but I'll cope.
>
> Daniel, can you please resend everything in a nice clean coherent
> stream?
>

I did not mean to miss the merge window, but I ended up being out the majority of December -> yesterday.

Now that I am back, I don't think you have to burden Andrew here.  I'll send a pull request for what is in kgdb-next since it is cleanups and fixes, and regression test anything else Daniel has left.

Cheers,
Jason.

