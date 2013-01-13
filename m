Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab3AMUtD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 15:49:03 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:46863 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab3AMUtB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 15:49:01 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <50F31CB9.4010905@linaro.org>
References: <CA+icZUXCObXMqVMNLFL58fZCBzo8dv+mqa7Ue_+jVfAdaYG45A@mail.gmail.com>
	<CA+icZUUUjQTVunewhv+wEsrvyD4FsG9riHa8MRrZdMufyttA4w@mail.gmail.com>
	<50F31CB9.4010905@linaro.org>
Date: Sun, 13 Jan 2013 21:49:00 +0100
Message-ID: <CA+icZUUTdW8d3HhB0qinQm8Vq89oytoVoduuwxvrsYxw2FmjuA@mail.gmail.com>
Subject: Re: [PATCH] cpuidle: fix new C-states not functional after AC disconnect
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Thomas Schlichter <thomas.schlichter@web.de>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 9:44 PM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> On 01/13/2013 09:36 PM, Sedat Dilek wrote:
>> 0001: Refreshed 1-2 as v3 against Linux v3.8-rc3.
>> 0002: v2 of 2-2 applied cleanly after 1-2 was refreshed!
>
> Hi Sedat,
>
> for the moment, you should use only the 1/2 because 2/2 (which is an
> optimization) is wrong.
>

Thanks, I wanted to test this cpuidle-fixes right now.

Just FYI:
Your original 1-2 (v2) patch does ***NOT*** apply against Linux v3.8-rc3!
I have sent a v3 already to the MLs.

- Sedat -

> Regards.
>
>   -- Daniel
>
>> Have fun!
>>
>> - Sedat -
>>
>> On Sun, Jan 13, 2013 at 8:30 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> Hi Thomas,
>>>
>>> I read your original LKML posting in [1].
>>>
>>> [ QUOTE ]
>>> Currently, Daniel Lezcano seems to be working on an intrusive change of not
>>> using the power_usage value at all for choosing a C-state:
>>>
>>> [4] https://lkml.org/lkml/2012/12/14/155
>>>
>>> As I could not find any of these patches in any git trees to be merged for
>>> 3.8...
>>> [ /QUOTE ]
>>>
>>> You can find the patches at LKML ([2] and [3]) or patchwork ([4] and [5]).
>>>
>>> As a Linux-Next "customer" I know about Daniel's work for-next [5] but
>>> I did not found any other GIT repository of him.
>>> Striving through Daniel's other GIT repos I found idlestat [6] and
>>> powerdebug [7] tools which I want to test.
>>> ( So, thank you for your email! )
>>>
>>> Have fun!
>>>
>>> Regards,
>>> - Sedat -
>>>
>>> [0] http://marc.info/?l=linux-acpi&m=135808048905350&w=2
>>> [1] https://lkml.org/lkml/2012/12/14/153
>>> [2] https://lkml.org/lkml/2012/12/14/149
>>> [3] https://patchwork.kernel.org/patch/1878691/
>>> [4] https://patchwork.kernel.org/patch/1878701/
>>> [5] http://git.linaro.org/gitweb?p=people/dlezcano/cpuidle-next.git
>>> [6] http://git.linaro.org/gitweb?p=people/dlezcano/idlestat.git;a=summary
>>> [7] http://git.linaro.org/gitweb?p=people/dlezcano/powerdebug.git;a=summary
>
>
> --
>  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs
>
> Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
> <http://twitter.com/#!/linaroorg> Twitter |
> <http://www.linaro.org/linaro-blog/> Blog
>
