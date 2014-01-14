Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbaANGok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 01:44:40 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:60403 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaANGoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 01:44:34 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-bb-52d4dccf9a28
Message-id: <52D4DCCD.8040109@samsung.com>
Date: Tue, 14 Jan 2014 10:44:29 +0400
From: Alexey Perevalov <a.perevalov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, anton@enomsg.org,
        kyungmin.park@samsung.com, akpm@linux-foundation.org,
        cw00.choi@samsung.com, linux-man@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com>
 <52D40681.3030801@samsung.com> <877ga34wd1.fsf@tassilo.jf.intel.com>
In-reply-to: <877ga34wd1.fsf@tassilo.jf.intel.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t/xq7rn71wJMvj0TNNizvo1bBZHrn1n
	tzi4VdPi+pfnrBZnfutanG16w25xedccNos162ewO3B4TOj/xOgxf+dHRo871/aweZyY8ZvF
	o2/LKkaPz5vkAtiiuGxSUnMyy1KL9O0SuDI+PV7DVHCIrWLd5Y8sDYwrWbsYOTgkBEwkJixg
	72LkBDLFJC7cW8/WxcjFISSwlFFi/dcNUM5nRomTq/eygVTxCmhJbL+5jRnEZhFQldgzfQUT
	yCA2AQOJffdsQUxRgQiJo8s1IaoFJX5MvscCEhYRUJE4fooPJMwssI1RYsPhKBBbWMBV4sT2
	9awQm/oYJb71zATbxClgJDH7xFdmiAZriZWTtjFC2PISm9e8ZZ7AKDALyYpZSMpmISlbwMi8
	ilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMk4L/uYFx6zOoQowAHoxIP7wnGK0FCrIllxZW5
	hxglOJiVRHgrFwCFeFMSK6tSi/Lji0pzUosPMTJxcEo1ME5eNeHX+7Pmc34Xzr905cijq45c
	S6qf82T4JyyZspz9Sd70+aw3ONTVJF6nz2PNL898dGht6MUHy+p3WLDs5jMS9vu0/FTp4pUV
	qtOm8Bk9XZDv23Wa6UjeDAbZaIVPPiphSxd+/14/sbp4ftZc9s0TjzGfa9z8yt+Fcf69jw+W
	ThPrdAsyCLBQYinOSDTUYi4qTgQAs3SATFYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 09:36 PM, Andi Kleen wrote:
> Alexey Perevalov <a.perevalov@samsung.com> writes:
>
>> Hello all,
>>
>> one remark - timerfd is not documented in linux Documentation
>> directory at all.
>> I think it's better to have such description.
> The documentation is the manpage in man-pages.
>
> Ideally you change would come with the changed manpage
> too.
>
> -Andi
>
Hello Andi,
  thank you,

I found ./man2/timerfd_create.2 from 
http://git.kernel.org/pub/scm/docs/man-pages/man-pages is outdated.
TFD_TIMER_CANCEL_ON_SET isn't described, just mention "since linux 3.0"
Clockids CLOCK_REALTIME_ALARM, CLOCK_BOOTTIME_ALARM isn't mentioned at all.

I'm not technical writer, but I'll try to describe _ALARM clockids and 
flags introduced by Anton's patchset.


-- 
Best regards,
Alexey Perevalov
