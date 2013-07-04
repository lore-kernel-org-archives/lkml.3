Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab3GDT0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 15:26:48 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:57650 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab3GDT0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 15:26:47 -0400
MIME-Version: 1.0
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E617335A7@sisaex02sj>
References: <CA+55aFz1yMZ1q5daHdTA91pW5QtQ1Yids1dLD9b2JC-ruicNQw@mail.gmail.com>
	<B8EFE96D1287C24090BAD9D858E15E6172FFB9@sisaex02sj>
	<CA+55aFxuB_nx8fZ_kN8U=fMFOq43cKZC_HJbj=6vKo7-fDqNuw@mail.gmail.com>
	<CAKMK7uH0q1vSaVRigtZD2pf5ZeVLEv1sn+tsiO7ZWjJdt=DwBA@mail.gmail.com>
	<20130625125437.6e7bb2d4@jbarnes-desktop>
	<B8EFE96D1287C24090BAD9D858E15E617305B4@sisaex02sj>
	<20130625130816.55e6cb80@jbarnes-desktop>
	<B8EFE96D1287C24090BAD9D858E15E617306DD@sisaex02sj>
	<CA+i0qc64MqeZd3y2E4YOtxwxyWRPXqofJep1BGCeEHCdkJuxQg@mail.gmail.com>
	<B8EFE96D1287C24090BAD9D858E15E6173079B@sisaex02sj>
	<5B8DA87D05A7694D9FA63FD143655C1B028DB36B@HASMSX106.ger.corp.intel.com>
	<B8EFE96D1287C24090BAD9D858E15E61731A11@sisaex02sj>
	<B8EFE96D1287C24090BAD9D858E15E617335A7@sisaex02sj>
Date: Thu, 4 Jul 2013 22:26:44 +0300
X-Google-Sender-Auth: u9CtrooFRxAtn5t3BWvtp-EIO7U
Message-ID: <CA+i0qc7p=y0Y1xBk4CVAC47sr09rmaWdtwt2bw8KNFDSpsYYqA@mail.gmail.com>
Subject: Re: Linux 3.10-rc7
From: Tomas Winkler <tomas.winkler@intel.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 1, 2013 at 5:54 PM, Shuah Khan <shuah.kh@samsung.com> wrote:
> On 06/26/2013 04:24 PM, Shuah Khan wrote:
>> On 06/26/2013 04:12 PM, Winkler, Tomas wrote:
>>>
>>>
>
>>> 42f132f mei: me: clear interrupts on the resume path
>>> 2753ff5 mei: nfc: fix nfc device freeing
>>> 5e85b36 mei: init: Flush scheduled work before resetting the device
>>>
>>> Are you sure you have these 3 in?
>>>
>>
>> Checked the git log and yes I have all three commits. It appears this
>> problem is intermittent and hard to reproduce at least on 3.10-rc7. I
>> tried several times yesterday to capture the log and couldn't reproduce.
>>
>> -- Shuah
>
> Tomas,
>
> I saw the mei_me problem again, however couldn't save the logs. I am
> getting into the habit of saving dmesg as soon as system gets resumed to
> catch the dmesg buffer prior to mei getting into this state. There is
> another difference in suspend sequence between 3.9.8 and 3.10-rc6 and rc-7.
>
> When I do echo disk > state,
>
> Screen clears and instead of going into console mode like it does on
> 3.9.8, it will get back into graphics mode and show the screen exactly
> the way it was right after echo disk > state command was issued. It
> stays in that state for good 60 seconds or more and then I see the
> suspend complete.
>
> I can start bi-sect of this problem on intel-display scope if you would
> like me to. Please let me know if the bisect scope should be larger.
>
> -- Shuah

I got finally an older system where this reproduces consistently, I'm
trying to root cause that now.
As soon I have something to test I will send it out.

Thanks
Tomas
