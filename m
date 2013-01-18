Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab3ARA0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 19:26:35 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:39693 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab3ARA0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 19:26:33 -0500
MIME-Version: 1.0
In-Reply-To: <A3397C8B8B789E45844E7EC5DEAD89D02DC30C27@sausexdag04.amd.com>
References: <CAKocOOMagCzn7fkkZJM+r5K--yXjZ40jCsHpwi97gCKo1keZ1A@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC2FB3A@sausexdag04.amd.com>
	<CAKocOOMrTf9RMa17Zy_oK+uPJ_B7uNwxhsX7dOm4okVdnmwY5A@mail.gmail.com>
	<A3397C8B8B789E45844E7EC5DEAD89D02DC30C27@sausexdag04.amd.com>
Date: Thu, 17 Jan 2013 17:26:29 -0700
Message-ID: <CAKocOOPNf5HZOO421Cvhb35fMxM6Tfu7w2aXZb3UF3igS9S=Kw@mail.gmail.com>
Subject: Re: linux 3.8-rc3 reboot and shutdown
From: Shuah Khan <shuahkhan@gmail.com>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "jglisse@redhat.com" <jglisse@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 4:48 PM, Deucher, Alexander
<Alexander.Deucher@amd.com> wrote:
>> -----Original Message-----
>> From: Shuah Khan [mailto:shuahkhan@gmail.com]
>> Sent: Thursday, January 17, 2013 6:21 PM
>> To: Deucher, Alexander
>> Cc: jglisse@redhat.com; linux-kernel@vger.kernel.org
>> Subject: Re: linux 3.8-rc3 reboot and shutdown
>>
>> On Thu, Jan 17, 2013 at 12:45 PM, Deucher, Alexander
>> <Alexander.Deucher@amd.com> wrote:
>> >> -----Original Message-----
>> >> From: Shuah Khan [mailto:shuahkhan@gmail.com]
>> >> Sent: Thursday, January 17, 2013 2:03 PM
>> >> To: jglisse@redhat.com; Deucher, Alexander
>> >> Cc: linux-kernel@vger.kernel.org; Shuah Khan
>> >> Subject: linux 3.8-rc3 reboot and shutdown
>> >>
>> >> Alex,
>> >>
>> >> I started seeing hang during shutdown and reboot on my laptop that has
>> >> ATI radeon VGA.
>> >>
>> >> 01:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee
>> >> ATI RV620 [Mobility Radeon HD 3400 Series] (prog-if 00 [VGA
>> >> controller])
>> >>
>> >> My bisect narrowed it to the following commit.
>> >
>> > Should be fixed by this commit:
>> > http://cgit.freedesktop.org/~agd5f/linux/commit/?h=drm-fixes-
>> 3.8&id=19fc42ed9950d5fe17089c0a928121047c882092
>> > Which should be finding its way upstream any day now.
>> >
>> > Alex
>> >
>>
>> Alex,
>>
>> Applied this patch on 3.8-rc3 and tested it. reboot still hung. The
>> only thing that fixes the problem is reverting
>> 71e3d1578c954cf29f1f4db1c8930d3574025eb0
>
> Does the attached patch applied in addition to:
> http://cgit.freedesktop.org/~agd5f/linux/commit/?h=drm-fixes-3.8&id=19fc42ed9950d5fe17089c0a928121047c882092
> fix the issue?
>
> Alex

No reboot still hung after applying
0001-drm-radeon-don-t-attempt-to-soft-reset-DMA-ring-on-r.patch  in
addition to 19fc42ed9950d5fe17089c0a928121047c882092

-- Shuah
