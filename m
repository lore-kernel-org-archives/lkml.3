Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbaBUXCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:02:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60363 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500AbaBUXCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:02:10 -0500
Message-ID: <5307DAC7.3090002@zytor.com>
Date: Fri, 21 Feb 2014 15:01:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, Jianguo Wu <wujianguo@huawei.com>,
        Andy Honig <ahonig@google.com>, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] x86, kaslr: randomize module base load address
References: <20140221202110.GA29885@www.outflux.net>	<20140221123658.5752f75eea6506d17bfa313b@linux-foundation.org>	<CAGXu5jLGBJp7oKXjausV70bXF-RTVDXxdZriS0cJ7X6NO90Ybg@mail.gmail.com>	<20140221131531.2db80023c59895a930cf374f@linux-foundation.org>	<5307C2A2.5010006@zytor.com> <20140221132708.52054104059b785080c76e3b@linux-foundation.org>
In-Reply-To: <20140221132708.52054104059b785080c76e3b@linux-foundation.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2014 01:27 PM, Andrew Morton wrote:
> On Fri, 21 Feb 2014 13:18:26 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
>> On 02/21/2014 01:15 PM, Andrew Morton wrote:
>>>>
>>>> I've been slapped down for adding more config options in the past, and
>>>> I think it's unlikely that people using CONFIG_RANDOMIZE_BASE won't
>>>> want the modules base randomized too. I think this is a safe default,
>>>> but if you see it as a requirement, I can change it.
>>>
>>> I think there were issues with some embedded systems where it's
>>> hard/impossible to provide/alter boot parameters.
>>>
>>
>> We now allow kernel parameters to be compiled into the kernel image for
>> that reason.
> 
> We do?  What's that Kconfig variable called?
> 

CONFIG_CMDLINE and CONFIG_CMDLINE_OVERRIDE.  They seem to be
x86-specific at this time, although I think some other arches have
similar hacks.

	-hpa

