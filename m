Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbaAJKHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:07:00 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:48793 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755288AbaAJKG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:06:57 -0500
Message-ID: <52CFC675.7040505@gmail.com>
Date: Fri, 10 Jan 2014 11:07:49 +0100
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: micky <micky_ching@realsil.com.cn>, wwang <wei_wang@realsil.com.cn>,
        Thomas Gleixner <tglx@linutronix.de>, Jingoo Han <jg1.han@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "'Borislav Petkov'" <bp@alien8.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
References: <alpine.DEB.2.02.1311290958560.30673@ionos.tec.linutronix.de> <5299FF38.7060203@gmail.com> <alpine.DEB.2.02.1312021145190.30673@ionos.tec.linutronix.de> <alpine.DEB.2.02.1312021219090.30673@ionos.tec.linutronix.de> <529D92D6.8050409@gmail.com> <20131209221721.GB8612@zurbaran> <52A670E4.5050501@realsil.com.cn> <52A674E0.2080407@realsil.com.cn> <20131210082955.GG8612@zurbaran> <52CFA095.3000709@gmail.com> <20140110095209.GU6003@zurbaran>
In-Reply-To: <20140110095209.GU6003@zurbaran>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 10:52 AM, Samuel Ortiz wrote:
> Hi Francis,
> 
> On Fri, Jan 10, 2014 at 08:26:13AM +0100, Francis Moreau wrote:
>> Hi.
>>
>> On 12/10/2013 09:29 AM, Samuel Ortiz wrote:
>>> Hi Micky,
>>>
>>> On Tue, Dec 10, 2013 at 09:56:48AM +0800, micky wrote:
>>>> Hi Francis:
>>>> On 12/10/2013 09:39 AM, wwang wrote:
>>>>> which is based on Thomas' patch.
>>>>
>>>> Can you help us test this patch, we disable irq while suspend here.
>>> I already pushed a patch from Thomas to mfd-fixes that seems to fix the
>>> resume breakage:
>>>
>>> https://git.kernel.org/cgit/linux/kernel/git/sameo/mfd-fixes.git/commit/?id=19e49e445e198197c5e243f92d333d076e23d032
>>>
>>
>> I still can see any traces of this fix in Linus' tree.
>>
>> Shouldn't this get merged before 3.13 is out ?
> Yes, it should. I just sent a pull request to Linus for that.

Thanks, you might consider to send this to the 3.12 stable tree as well.

