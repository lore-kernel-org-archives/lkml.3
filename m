Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaBDRze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:55:34 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:36553 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaBDRzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:55:32 -0500
X-AuditID: cbfec37d-b7ff46d000005528-2c-52f129925a24
Message-id: <52F1298F.1040903@samsung.com>
Date: Tue, 04 Feb 2014 10:55:27 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Jingoo Han <jg1.han@samsung.com>,
        "'Rafael J. Wysocki'" <rjw@rjwysocki.net>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Jean-Christophe PLAGNIOL-VILLARD'" <plagnioj@jcrosoft.com>,
        "'Tomi Valkeinen'" <tomi.valkeinen@ti.com>,
        "'Rafael J. Wysocki'" <rafael.j.wysocki@intel.com>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Shuah Khan'" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v2] backlight: Convert from Legacy pm ops to dev_pm_ops
References: <2236505237-3336-1-git-send-email-shuah.kh@samsung.com>
 <15798389.lgk83XnI1i@vostro.rjw.lan>
 <001f01cf157f$ca2e8530$5e8b8f90$%han@samsung.com>
 <52DD4045.4050902@samsung.com>
In-reply-to: <52DD4045.4050902@samsung.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.13]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9hX91Jmh+DDC5sNbLonHmN0eLywkus
	Fif6PrBaXN41h81i3cMXTBaPV7xltzhzGiixe9dTVouvPx0s1s+/xebA5bFz1l12jw8f4zwW
	73nJ5PHqwh0Wjy1X21k89sz/werRt2UVo8fxG9uZPD5vkgvgjOKySUnNySxLLdK3S+DKWLGl
	m7Ggi7Xiz6aH7A2MPSxdjJwcEgImEre3bWOCsMUkLtxbz9bFyMUhJLCMUaJvy0xWCKeXSWJX
	92OwKiGBTYwSaxaUgdi8AloS7Yd2sYLYLAKqEie/3mAGsdkE1CU+v97BDlEvJ9G0ZDVYXFQg
	QuLV2YksEL2CEj8m3wOzRQT8JbZ+3MECsoxZoINZ4tnRRrAGYQFviY4za5ggrtjPKDF1/Wyw
	qZwC2hIvfvwDs5kFzCQetaxjhrDlJTavecsMsVlZ4s/lU1C/KUpM/H2BeQKjyCwky2chaZ+F
	pH0BI/MqRrHS4uSC4qT01AoTveLE3OLSvHS95PzcTYyQeKzdwXj/q80hRgEORiUe3g7Rj0FC
	rIllxZW5hxglOJiVRHjNPn8IEuJNSaysSi3Kjy8qzUktPsTIxMEp1cC47O8ivgCNpUztr6Ic
	3xumqKww2hmztUFT6LqxMPfZT9P5r727L3Zo9xQZ+XcbP0w8djVU/+pn3mV1p4RD7R8zF8Zs
	ERCs33HC+HLIj5mCrDNNpOdGyvZkq81ttgk/fndJTtXpF5z8c2MWb7HwujLRRU2L6XX8w7iq
	z+f61JiMk+NPihdX7jyrxFKckWioxVxUnAgABWI7/aUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2014 08:27 AM, Shuah Khan wrote:
> On 01/19/2014 06:34 PM, Jingoo Han wrote:
>> On Monday, January 20, 2014 12:37 AM, Rafael J. Wysocki wrote:

> Rafael/Jingoo Han,
>
> I did send the v3 patch with the typo fixed. Here is the link:
>
> http://lkml.indiana.edu/hypermail/linux/kernel/1306.0/00219.html
>
> This is a while back. I will rebase and res-test and send it.
>

Checked 3.14-rc1 and patch v3 is in there.

commit 3601792e7b68150420ea8dc129e26e167c0484d8

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
