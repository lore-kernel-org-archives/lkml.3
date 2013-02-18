Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050Ab3BRH06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 02:26:58 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:37477 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab3BRH05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 02:26:57 -0500
MIME-Version: 1.0
In-Reply-To: <51219C56.8060504@canonical.com>
References: <511D0BCC.9070208@canonical.com>
	<20130215073210.GM7867@spo001.leaseweb.com>
	<511E4C43.7080403@canonical.com>
	<CAHh0gOgeWn5QaDGzgstft7AoQsKdoZ+4Utp8iQxxSCO0q=cZ-Q@mail.gmail.com>
	<51219C56.8060504@canonical.com>
Date: Mon, 18 Feb 2013 02:26:56 -0500
Message-ID: <CAGHUO12ROdB4=LVyod7+RaoONHfMfiyLAj73cC+BczLGDG+i+Q@mail.gmail.com>
Subject: Re: [v3.8 Regression] watchdog: sp5100_tco: Add SB8x0 chipset support
From: Joseph Salisbury <josephtsalisbury@gmail.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Tanaka Takahisa <mc74hc00@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've requested a digital image or screen capture of the panic.  Is
there any additional debug information you thing would be helpful?

Thanks,

Joe

On Sun, Feb 17, 2013 at 10:13 PM, Joseph Salisbury
<joseph.salisbury@canonical.com> wrote:
> On 02/17/2013 04:44 AM, Tanaka Takahisa wrote:
>>
>> Hi Joseph,
>>
>> 2013/2/15 Joseph Salisbury <joseph.salisbury@canonical.com>:
>>>
>>> On 02/15/2013 02:32 AM, Wim Van Sebroeck wrote:
>>>>
>>>> Hi Joseph,
>>>>
>>>>> A bug was opened against the Ubuntu kernel[0].  It was found that
>>>>> reverting the following commit resolved this bug:
>>>>>
>>>>> commit 740fbddf5c3f9ad8b23c5d917ba1cc7e376a5104
>>>>> Author: Takahisa Tanaka <mc74hc00@gmail.com>
>>>>> Date:   Sun Dec 2 14:33:18 2012 +0900
>>>>>
>>>>>       watchdog: sp5100_tco: Add SB8x0 chipset support
>>>>>
>>>>>
>>>>> The regression was introduced as of v3.8-rc1.
>>>>>
>>>>> I see that you are the author of this patch, so I wanted to run this by
>>>>> you.  I was thinking of requesting a revert for v3.8, but I wanted to
>>>>> get your feedback first.
>>>>
>>>> Please check out the attached patches first (They are allready in
>>>> linux-next).
>>>
>>> Thanks for the feedback, Wim.  I'll let you know if the patches resolve
>>> this
>>> bug.
>>>
>>>
>>>> Other references:
>>>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43176
>>>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43176
>>>>
>>>> Kind regards,
>>>> Wim.
>>
>> Thank you for your information, and sorry for the late reply.
>>
>> I think that I will get rid of code that re-programming the chipset
>> registers, if my patch set doesn't resolve the problem.
>> I'm waiting for your reply at the moment.
>>
>>
>> Regards,
>> Takahisa
>
> Hi Takahisa,
>
> The bug report tested a kernel with the patches.  However, he reports the
> kernel panic still occurs[0].
>
> Thanks,
>
> Joe
>
> [0] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1116835
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
