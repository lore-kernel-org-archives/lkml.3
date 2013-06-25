Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab3FYVLt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:11:49 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:48956 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab3FYVLr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:11:47 -0400
X-AuditID: cbfec37b-b7f306d0000047de-8a-51ca0792c73f
From: Shuah Khan <shuah.kh@samsung.com>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: Linux 3.10-rc7
Thread-topic: Linux 3.10-rc7
Thread-index: AQHOcO9Wy94BEELWoUiZdIX6E3dp1w==
Date: Tue, 25 Jun 2013 21:11:45 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E6173079B@sisaex02sj>
References: <CA+55aFz1yMZ1q5daHdTA91pW5QtQ1Yids1dLD9b2JC-ruicNQw@mail.gmail.com>
 <B8EFE96D1287C24090BAD9D858E15E6172FFB9@sisaex02sj>
 <CA+55aFxuB_nx8fZ_kN8U=fMFOq43cKZC_HJbj=6vKo7-fDqNuw@mail.gmail.com>
 <CAKMK7uH0q1vSaVRigtZD2pf5ZeVLEv1sn+tsiO7ZWjJdt=DwBA@mail.gmail.com>
 <20130625125437.6e7bb2d4@jbarnes-desktop>
 <B8EFE96D1287C24090BAD9D858E15E617305B4@sisaex02sj>
 <20130625130816.55e6cb80@jbarnes-desktop>
 <B8EFE96D1287C24090BAD9D858E15E617306DD@sisaex02sj>
 <CA+i0qc64MqeZd3y2E4YOtxwxyWRPXqofJep1BGCeEHCdkJuxQg@mail.gmail.com>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t9hP91J7KcCDfpPy1tcvbWAyeLmw7Os
	Fgsf3mW2mD1hM5PFozMn2S0u75rDZvH1p4PFh546i0d9b9kdOD1WftDy2PttAYvHzll32T0W
	73nJ5HFixm8Wj/vdx5k83u+7yubxeZOcx7eve5kCOKO4bFJSczLLUov07RK4Mt5v+MRcMIOn
	YvvkjywNjH85uxg5OSQETCRmTp3BAmGLSVy4t56ti5GLQ0hgGaPEq56prBBOL5PEogttTBDO
	fEaJlsc9zCAtbALqEp9f72AHsUUEtCVmvfwO1sEsMJFZYsLXfUBzOTiEBaQlXh6SgaiRkZjZ
	+pEVwtaTOPXvHJjNIqAq8fHyU7AzeAXsJRbf6oRatpBF4vrhQ2DLGIHu+35qDROIzSwgLtHc
	ehPqbgGJJXvOM0PYohIvH/9jBdkrIaAosX21FUS5lsT6ncehWrUlnry7wAqxS1Dix+R7LBMY
	xWYhmToLScssJC2zkLQsYGRZxShWWpxcUJyUnlphpFecmFtcmpeul5yfu4kREsnVOxjvfrU5
	xCjAwajEw3ti08lAIdbEsuLK3EOMEhzMSiK8+TeAQrwpiZVVqUX58UWlOanFhxiZODilGhgL
	Eg1fCzifm9ejtDNjvt4xyZOaCVkXE3Zc3pr48sQjbvkrkdu+9Bh3Kk/unqyVeU05Ut1I6NzV
	P4w6k9fdkEzc9+KfUHen4z6hkO8tn8SiEjarnvqyKOj6uj0aUVsWJTA492xxTWrsqpPpThAP
	NfK0vWHDKhuRwGVW9Od47t2Y7+WVl8+scFFiKc5INNRiLipOBACMsdljwgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2013 02:57 PM, Tomas Winkler wrote:
> On Tue, Jun 25, 2013 at 11:51 PM, Shuah Khan <shuah.kh@samsung.com> wrote:
>>

>> With this patch warn_on went away. Resume worked. I started seeing:
>>
>> [   78.733062] mei_me 0000:00:16.0: unexpected reset: dev_state =
>> RESETTING
>> [   78.733079] mei_me 0000:00:16.0: reset: wrong host start response
>> [   78.733082] mei_me 0000:00:16.0: unexpected reset: dev_state =
>> RESETTING
>>
>> over and over again after resume from reboot mode suspend. dmesg filled
>> up with these messages.
>
> Can you please send me the log part when this starts?
>
> Thanks
>

It rolled over and I don't have prior messages. I tried reproducing 
twice and didn't see it again. I will try a few more times and see if I 
can get it to happen again.

This is what I could save before dmesg rolled over:

[   78.709014] mei_me 0000:00:16.0: reset: wrong host start response
[   78.709016] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
[   78.709029] mei_me 0000:00:16.0: reset: unexpected enumeration 
response hbm.
[   78.709031] mei_me 0000:00:16.0: unexpected reset: dev_state = RESETTING
[   78.709069] mei_me 0000:00:16.0: reset: wrong host start response

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
