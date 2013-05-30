Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754963Ab3E3NHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:07:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:44440 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab3E3NHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:07:45 -0400
X-AuditID: cbfee691-b7fef6d000002d62-98-51a74f1edd8a
Message-id: <3D99F44C56954EC59167436E26BE91F6@sisodomain.com>
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Jingoo Han <jg1.han@samsung.com>,
        "'Tushar Behera'" <tushar.behera@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, "'Kevin Hilman'" <khilman@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'Patch Tracking'" <patches@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        Julius Werner <jwerner@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>
References: <1368168599-28507-1-git-send-email-tushar.behera@linaro.org>
 <87sj1qzaov.fsf@linaro.org> <5191AA89.6010901@linaro.org>
 <20130528231740.GA28879@quad.lixom.net> <51A57D39.8030506@linaro.org>
 <CAOesGMh50Dzr_jczHZC5_txfW=6a+7EgFKvgZgj9MhUcVUTJ1Q@mail.gmail.com>
 <51A5C16D.20408@linaro.org> <000001ce5c4f$839f4cb0$8adde610$@samsung.com>
In-reply-to: <000001ce5c4f$839f4cb0$8adde610$@samsung.com>
Subject: Re: [PATCH] ARM: EXYNOS: Update defconfig for Arndale and Origen board
Date: Thu, 30 May 2013 18:40:55 +0530
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=iso-8859-1; reply-type=original
Content-transfer-encoding: 7bit
X-Priority: 3
X-MSMail-priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MIMEOLE: Produced By Microsoft MimeOLE V14.0.8117.416
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsWyRsSkRlfef3mgwYbfbBZ/Jx1jtzi77CCb
	RduVg+wWlxdeYrXoOPSYyaJ3wVU2i6+HVzBabHp8jdXi8q45bBYzzu9jsjh1/TObxZTDX1gs
	js1YwmjR/ncvmwOfx+9fkxg9ZjdcZPG4c20Pm8fmJfUeV040sXr0bVnF6PF5k1wAexSXTUpq
	TmZZapG+XQJXxsKb/1kKmuUrdv/sYmpgPCDRxcjJISFgIvHm7VZGCFtM4sK99WxdjFwcQgJL
	GSVuflzKDlP0oaORFSKxiFHix6odTBDOd0aJJ2c3ArVwcPAK2Ersv2IK0sAmoCvR9HYX2FQR
	gVKJxUvns4PUMwtcYJZ4cHoJI0TzfSaJGUuvgFVxClhJ/Hp4hAnEFhbwl7jxfRYziM0ioCpx
	8+xqsBpeAUGJH5PvsYDYzAIBEisnzmaEsOUlNq95ywxxKq/EjPanLBC2pMTqnlvsEPOFJDqu
	drJCxI0lpvxbClVvLnFx+2awbyQEjnBInPnVxwSxWEDi2+RDLCCfSQjISmw6wAwz8+CKGywT
	GKVmITlpFpKTZiE5aQEj8ypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MwJRx+t+ziTsY7x+w
	PsSYDLRyIrOUaHI+MOXklcQbGpsZWZiamBobmVuakSasJM6r3mIdKCSQnliSmp2aWpBaFF9U
	mpNafIiRiYNTqoHRSsOs3rre8mN615FDbxQjd8Z80eLrM11iyXo5wN1h99vPyRtbUuynGX9+
	d13/gEHu/V3eK3ofi9l+vPmt9KVz/e0/DA0r/h55n9wUsNeu9SFbfEveqUevbu3r1G1R8nt+
	x8x5cWaV1+P7rZLK3v0sK1UOfHrEHNMdKrR+/6NDYXlSMc3botWVWIozEg21mIuKEwEYrAZE
	LwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJKsWRmVeSWpSXmKPExsVy+t9jAV05/+WBBj/aLC3+TjrGbnF22UE2
	i7YrB9ktLi+8xGrRcegxk0XvgqtsFl8Pr2C02PT4GqvF5V1z2CxmnN/HZHHq+mc2iymHv7BY
	HJuxhNGi/e9eNgc+j9+/JjF6zG64yOJx59oeNo/NS+o9rpxoYvXo27KK0ePzJrkA9qgGRpuM
	1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJuVFMoSc0qB
	QgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBkLb/5nKWiWr9j9s4upgfGARBcjJ4eE
	gInEh45GVghbTOLCvfVsXYxcHEICixglfqzawQThfGeUeHJ2I1CGg4NXwFZi/xVTkAY2AV2J
	pre7GEFsEYFSicVL57OD1DMLXGCWeHB6CSNE830miRlLr4BVcQpYSfx6eIQJxBYW8Je48X0W
	M4jNIqAqcfPsarAaXgFBiR+T77GA2MwCARIrJ85mhLDlJTavecsMcSqvxIz2pywQtqTE6p5b
	7BDzhSQ6rnZCvWMsMeXfUqh6c4mL2zczTWAUmYVkxSwkK2YhWbGAkXkVo2hqQXJBcVJ6rqFe
	cWJucWleul5yfu4mRnBCeia1g3Flg8UhRgEORiUe3g1aywKFWBPLiitzDzFKcDArifAWOC8P
	FOJNSaysSi3Kjy8qzUktPsSYDPTpRGYp0eR8YLLMK4k3NDYxNzU2tTSxMDGzJE1YSZz3QKt1
	oJBAemJJanZqakFqEcwWJg5OqQbGDM7nUeKTt0jwJMYXsnvt/vTpR9STQDWuvM0/pfb8ncWu
	9Ok90zGh67P+JyUEVAdkxl6bvWC9gpq16Yb6TWdXMFcbyfJ+3nJo0nLG3DsPOeZkRk87ONEq
	9J7USy2VFxyKBstT9ih2F3h4lydyBX1/7Cyd4PMwx+PFCsOJc7O47+rPE+KbFnVbiaU4I9FQ
	i7moOBEAIolAo4wDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Wednesday, May 29, 2013 5:51 PM, Tushar Behera:
>> On 05/29/2013 11:01 AM, Olof Johansson wrote:
>> > On Tue, May 28, 2013 at 8:59 PM, Tushar Behera 
>> > <tushar.behera@linaro.org> wrote:
>> >
>> >> The patches are at [1].
>> >
>> > FWIW, a cgit/gitweb link is easier to follow when you're reading an
>> > email. Anyway, found the patches.
>> >
>> >> There are a total of 6 patches on top of
>> >> v3.10-rc3. 3 of them (a, b, d) are queued for 3.10-rc4 and another 
>> >> patch
>> >> (c) is just a defconfig hack to get Arndale booting. Remaining 2 
>> >> patches
>> >> (e, f) are required to reset the hub during EHCI initialization.
>> >
>> > Huh, I thought you said that (c) wasn't needed when I posted the
>> > defconfig update. It'd be nice to see the code fixed to handle this
>> > case instead of Linaro carrying a patch like this though. I.e. make it
>> > able to deselect the uart, or make it tied to DEBUG_LL like on other
>> > platforms instead of having a separate config for this.
>> >
>>
>> It would be good to free up the dependency on the correct UART port for
>> the board to boot. Without that, there would always be boards that don't
>> boot with default mainline defconfig file even though all other
>> components are in place.
>>
>> >> a. ARM: exynos: defconfig update
>> >> b. ARM: EXYNOS: Update defconfig for Arndale and Origen board
>> >> c. [TEMP] ARM: EXYNOS: Set low-level UART port to 2
>> >> d. ARM: dts: Enabling samsung-usb2phy driver for exynos5250
>> >> e. usb: ehci-s5p: add the HSIC port initialization
>> >> f. ARM: dts: Add USB gpio entries for Arndale board
>> >>
>> >> I am not sure whether such kind of board-specific patches (e, f) are
>> >> appreciated in the drivers. But that is all we need to get USB and
>> >> Ethernet to work on v3.10-rc3 kernel.
>> >
>> > I've come across a similar situation with wifi reset sequence on the
>> > chromebook. On the product kernel we added some code to the board file
>> > to deal with it, but if we keep doing that things will grow out of
>> > hand.
>> >
>> > I don't know if it'll be unpopular, but I think it's time to start a
>> > drivers/platform/arm for these kind of things, and have those drivers
>> > probe on the system compatible value, similar to how x86 does it (with
>> > DMI tables). At least that's my plan for approaching the wifi
>> > reset/power-on sequence on the Chromebook. I hope to have patches in
>> > not all that long...
>> >
>> > Likewise, the hub reset/enable code doesn't have to go with the USB
>> > driver, right? I.e. if you cycle reset/enable on the hub after the
>> > host and phy is configured, you'll still have a working setup?
>> >
>>
>> Right, hub reset/enable code need not be tied up with USB driver. As per
>> your suggestion regarding drivers/platform/arm, I implemented an Arndale
>> specific driver [2] in drivers/platform/arm and verified USB and
>> ethernet to be working.
>
> CC'ed Thomas Abraham, Vivek Gautam
>
> I think so.
>
> I looked at Arndale board Schematics.
> 'Hub chip' on Arndale board needs hub reset/enable code.
> 'HUB_RESET' and 'HUB_CONNECT' pins are used to reset 'Hub chip'
> on Arndale board, not Exynos EHCI controller. So, Exynos EHCI driver
> does not need to consider this hub reset/enable code.
>
> If there is a driver for this 'Hub chip', 'Hub chip' driver maybe
> consider this.
>
> However, Olof Johansson mentioned, 'drivers/platform/arm/board_arndale.c'
> would be a good alternative.

We do have a driver for USB3503 in upstream now, which has enough 
infrastructure for us to use.
We just want to handle states of HUB_CONNECT line or RESET_N line, which 
should just be fine with this driver.

Am I missing something ?

>
>>
>> [2]
>> https://git.linaro.org/gitweb?p=landing-
>> teams/working/samsung/kernel.git;a=shortlog;h=refs/heads/upstream/arndale-usb-2
>
> It looks good.


Regards
Vivek 

