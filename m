Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab3GAOzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:55:06 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:12892 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab3GAOzD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:55:03 -0400
X-AuditID: cbfec37d-b7f036d000004805-f4-51d19845d461
From: Shuah Khan <shuah.kh@samsung.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: Linux 3.10-rc7
Thread-topic: Linux 3.10-rc7
Thread-index: AQHOcO9Wy94BEELWoUiZdIX6E3dp1w==
Date: Mon, 01 Jul 2013 14:54:59 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E617335A7@sisaex02sj>
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
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t9hX13XGRcDDb49EbG4emsBk8XNh2dZ
	LRY+vMtsMXvCZiaLR2dOsltc3jWHzeLrTweLDz11Fo/63rI7cHqs/KDlsffbAhaPnbPusnss
	3vOSyePEjN8sHve7jzN5vN93lc3j8yY5j29f9zIFcEZx2aSk5mSWpRbp2yVwZfz5dYOloIO3
	4uj7SywNjAe4uhg5OCQETCR29Pl2MXICmWISF+6tZ+ti5OIQEljGKHH+209mkISQQC+TxO99
	BRCJ+YwSq6ceZQRJsAmoS3x+vYMdxBYRUJVoufoYrJtZ4B2zxI7li9lANggLSEu8PCQDUSMj
	MbP1IyuErSdx6t85MJsFqHfK151gc3gF7CV+/tjOBLHsOqvExUVnwK5gBDrv+6k1TCA2s4C4
	RHPrTRaIswUkluw5zwxhi0q8fPyPFeIzRYntq60gyrUk1u88DtWqLfHk3QVWiF2CEj8m32OZ
	wCg2C8nUWUhaZiFpmYWkZQEjyypGsdLi5ILipPTUChO94sTc4tK8dL3k/NxNjJAort3BeP+r
	zSFGAQ5GJR7eHzMvBAqxJpYVV+YeYpTgYFYS4b3pfTFQiDclsbIqtSg/vqg0J7X4ECMTB6dU
	A6PDppL3+woD8gPPM12/dMhfZ1aJbe27TXz/4vJsluQZyygJ/ToTeW31HyvhhsMep00eWOQ6
	sLxaY5nkdPv6PvYVJRMLSlz3/w3X2C18+nYDn9OsW7tvVVnMLxfXsG7Rjz8502rPmXl+FZK3
	805ZRK1NrEkNiPvlXq3yumZxw5+NdWZ8v3lk1iixFGckGmoxFxUnAgBtxbUxwAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 04:24 PM, Shuah Khan wrote:
> On 06/26/2013 04:12 PM, Winkler, Tomas wrote:
>>
>>

>> 42f132f mei: me: clear interrupts on the resume path
>> 2753ff5 mei: nfc: fix nfc device freeing
>> 5e85b36 mei: init: Flush scheduled work before resetting the device
>>
>> Are you sure you have these 3 in?
>>
>
> Checked the git log and yes I have all three commits. It appears this
> problem is intermittent and hard to reproduce at least on 3.10-rc7. I
> tried several times yesterday to capture the log and couldn't reproduce.
>
> -- Shuah

Tomas,

I saw the mei_me problem again, however couldn't save the logs. I am 
getting into the habit of saving dmesg as soon as system gets resumed to 
catch the dmesg buffer prior to mei getting into this state. There is 
another difference in suspend sequence between 3.9.8 and 3.10-rc6 and rc-7.

When I do echo disk > state,

Screen clears and instead of going into console mode like it does on 
3.9.8, it will get back into graphics mode and show the screen exactly 
the way it was right after echo disk > state command was issued. It 
stays in that state for good 60 seconds or more and then I see the 
suspend complete.

I can start bi-sect of this problem on intel-display scope if you would 
like me to. Please let me know if the bisect scope should be larger.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
