Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab3BQJo3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 04:44:29 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:33926 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab3BQJo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 04:44:27 -0500
MIME-Version: 1.0
In-Reply-To: <511E4C43.7080403@canonical.com>
References: <511D0BCC.9070208@canonical.com>
	<20130215073210.GM7867@spo001.leaseweb.com>
	<511E4C43.7080403@canonical.com>
Date: Sun, 17 Feb 2013 18:44:25 +0900
Message-ID: <CAHh0gOgeWn5QaDGzgstft7AoQsKdoZ+4Utp8iQxxSCO0q=cZ-Q@mail.gmail.com>
Subject: Re: [v3.8 Regression] watchdog: sp5100_tco: Add SB8x0 chipset support
From: Tanaka Takahisa <mc74hc00@gmail.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joseph,

2013/2/15 Joseph Salisbury <joseph.salisbury@canonical.com>:
> On 02/15/2013 02:32 AM, Wim Van Sebroeck wrote:
>>
>> Hi Joseph,
>>
>>> A bug was opened against the Ubuntu kernel[0].  It was found that
>>> reverting the following commit resolved this bug:
>>>
>>> commit 740fbddf5c3f9ad8b23c5d917ba1cc7e376a5104
>>> Author: Takahisa Tanaka <mc74hc00@gmail.com>
>>> Date:   Sun Dec 2 14:33:18 2012 +0900
>>>
>>>      watchdog: sp5100_tco: Add SB8x0 chipset support
>>>
>>>
>>> The regression was introduced as of v3.8-rc1.
>>>
>>> I see that you are the author of this patch, so I wanted to run this by
>>> you.  I was thinking of requesting a revert for v3.8, but I wanted to
>>> get your feedback first.
>>
>> Please check out the attached patches first (They are allready in
>> linux-next).
>
> Thanks for the feedback, Wim.  I'll let you know if the patches resolve this
> bug.
>
>
>>
>> Other references:
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43176
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43176
>>
>> Kind regards,
>> Wim.

Thank you for your information, and sorry for the late reply.

I think that I will get rid of code that re-programming the chipset
registers, if my patch set doesn't resolve the problem.
I'm waiting for your reply at the moment.


Regards,
Takahisa
