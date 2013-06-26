Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab3FZWYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 18:24:09 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:29575 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab3FZWYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 18:24:06 -0400
X-AuditID: cbfec37d-b7f036d000004805-2c-51cb6a0401e5
From: Shuah Khan <shuah.kh@samsung.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
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
Date: Wed, 26 Jun 2013 22:24:03 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61731A11@sisaex02sj>
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
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t9hP12WrNOBBrdny1hcvbWAyeLmw7Os
	Fgsf3mW2mD1hM5PFozMn2S0u75rDZvH1p4PFh546i0d9b9kdOD1WftDy2PttAYvHzll32T0W
	73nJ5HFixm8Wj/vdx5k83u+7yubxeZOcx7eve5kCOKO4bFJSczLLUov07RK4MpZu2MdasJ63
	Yvq1H8wNjK+4uhg5OSQETCSav1xihrDFJC7cW8/WxcjFISSwjFHi3a/LrBBOL5PE3vezmSCc
	+YwS9++9ZwFpYRNQl/j8egc7iC0ioCdxa/UcdpAiZoGJzBITvu4DKuLgEBaQlnh5SAaiRkZi
	ZutHVpj6U//OgdksAqoS03+dZQKxeQXsJeZ+OQm1bCGrxLfNh8ESjED3fT+1BsxmFhCXaG69
	yQJxt4DEkj3noX4QlXj5+B8ryF4JAUWJ7autIMq1JNbvPA7Vqi3x5N0FVohdghI/Jt9jmcAo
	NgvJ1FlIWmYhaZmFpGUBI8sqRrHS4uSC4qT01AoTveLE3OLSvHS95PzcTYyQSK7dwXj/q80h
	RgEORiUe3g+MpwOFWBPLiitzDzFKcDArifBaewKFeFMSK6tSi/Lji0pzUosPMTJxcEo1MMY8
	5OVddzJOR0pK/Ok/3XuMNgwSBwvWqjyqZM2xPd1cIpewieWH1duDDPMiFtswMEvdn50qnTyf
	45GB1Smbkx9/dvb02mW80hK9U9g3c+kTOU0bnqwFOUfPyeflSz57oqf75tYfpvvTbnc9vLFW
	+PCujNq5R7Y4/vvfcmQ3zxu+6Y57re1MniqxFGckGmoxFxUnAgBST6SawgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 04:12 PM, Winkler, Tomas wrote:
>
>
>>> Can you please send me the log part when this starts?
>>>
>>> Thanks
>>>
>>
>> It rolled over and I don't have prior messages. I tried reproducing twice and
>> didn't see it again. I will try a few more times and see if I can get it to happen
>> again.
>>
>> This is what I could save before dmesg rolled over:
>>
>> [   78.709014] mei_me 0000:00:16.0: reset: wrong host start response
>> [   78.709016] mei_me 0000:00:16.0: unexpected reset: dev_state =
>> RESETTING
>> [   78.709029] mei_me 0000:00:16.0: reset: unexpected enumeration
>> response hbm.
>> [   78.709031] mei_me 0000:00:16.0: unexpected reset: dev_state =
>> RESETTING
>> [   78.709069] mei_me 0000:00:16.0: reset: wrong host start response
>>
> So far I was able to positively reproduce it with  3.10-rc5 but not with 3.10-rc7 and above.
>
> There are 3 patches that went in to fix this issue
>
> 42f132f mei: me: clear interrupts on the resume path
> 2753ff5 mei: nfc: fix nfc device freeing
> 5e85b36 mei: init: Flush scheduled work before resetting the device
>
> Are you sure you have these 3 in?
>

Checked the git log and yes I have all three commits. It appears this 
problem is intermittent and hard to reproduce at least on 3.10-rc7. I 
tried several times yesterday to capture the log and couldn't reproduce.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
