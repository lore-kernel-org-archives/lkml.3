Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbbAGTFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 14:05:25 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34220 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbbAGTFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 14:05:23 -0500
Message-ID: <54AD8341.8070809@oracle.com>
Date: Wed, 07 Jan 2015 14:04:33 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>, Greg KH <greg@kroah.com>
CC: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 1/2] time: settimeofday: Validate the values of tv from
 user
References: <1420654340-3009-1-git-send-email-john.stultz@linaro.org>	<1420654340-3009-2-git-send-email-john.stultz@linaro.org>	<20150107182845.GA7699@kroah.com> <CALAqxLUSzc8yePiQS=5=C6q73eWm87yPfp_ZjXh8Nh=ydE592Q@mail.gmail.com>
In-Reply-To: <CALAqxLUSzc8yePiQS=5=C6q73eWm87yPfp_ZjXh8Nh=ydE592Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 02:02 PM, John Stultz wrote:
> On Wed, Jan 7, 2015 at 10:28 AM, Greg KH <greg@kroah.com> wrote:
>> On Wed, Jan 07, 2015 at 10:12:19AM -0800, John Stultz wrote:
>>> From: Sasha Levin <sasha.levin@oracle.com>
>>>
>>> An unvalidated user input is multiplied by a constant, which can result in
>>> an undefined behaviour for large values. While this is validated later,
>>> we should avoid triggering undefined behaviour.
>>>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Cc: Ingo Molnar <mingo@kernel.org>
>>> Cc: stable <stable@vger.kernel.org>
>>> Cc: Andy Lutomirski <luto@amacapital.net>
>>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>>> [jstultz: include trivial milisecond->microsecond correction noticed
>>> by Andy]
>>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>>> ---
>>>  include/linux/time.h | 13 +++++++++++++
>>>  kernel/time/time.c   |  4 ++++
>>>  2 files changed, 17 insertions(+)
>>
>> <formletter>
>>
>> This is not the correct way to submit patches for inclusion in the
>> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
>> for how to do this properly.
>>
>> </formletter>
> 
> Hrm. I'm not quite sure which rule I'm running afoul here.
> 
> Does this seem too much like a theoretical issue and not like enough
> of a "oh, that's not good" issue?

I suspect it's something more like "Cc: stable <stable@vger.kernel.org>" vs
"Cc: stable@vger.kernel.org", but not really sure.


Thanks,
Sasha
