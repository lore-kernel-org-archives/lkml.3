Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965405AbaKNLNx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 06:13:53 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:28142 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965353AbaKNLNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 06:13:51 -0500
Message-ID: <5465E3DF.6050307@imgtec.com>
Date: Fri, 14 Nov 2014 11:13:35 +0000
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andy Yan <andy.yan@rock-chips.com>, <airlied@linux.ie>, <heiko@sntech.de>,
        <fabio.estevam@freescale.com>, <rmk+kernel@arm.linux.org.uk>
CC: Mark Rutland <mark.rutland@arm.com>, <dri-devel@lists.freedesktop.org>,
        <ykk@rock-chips.com>, <devel@driverdev.osuosl.org>,
        Arnd Bergmann <arnd@arndb.de>, <linux-rockchip@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Dave Airlie <airlied@redhat.com>, <jay.xu@rock-chips.com>,
        <devicetree@vger.kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Sean Paul <seanpaul@chromium.org>, <mark.yao@rock-chips.com>,
        Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <djkurtz@google.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v10 05/11] drm: bridge/dw_hdmi:split some phy configuration
 to platform driver
References: <1415934583-16290-1-git-send-email-andy.yan@rock-chips.com> <1415935631-16826-1-git-send-email-andy.yan@rock-chips.com> <5465D73C.9030507@imgtec.com> <5465DF0C.50301@rock-chips.com> <5465DFB2.8060601@imgtec.com> <5465E2BB.1070507@rock-chips.com>
In-Reply-To: <5465E2BB.1070507@rock-chips.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 14/11/14 11:08, Andy Yan wrote:
> 
> On 2014年11月14日 18:55, Zubair Lutfullah Kakakhel wrote:
>>
>> On 14/11/14 10:53, Andy Yan wrote:
>>> Hi ZubairLK:
>>>     Thanks for your review.
>>> On 2014年11月14日 18:19, Zubair Lutfullah Kakakhel wrote:
>>>> Hi Andy,
>>>>
>>>> Nice work on this patch series. Its getting better and better :).
>>>>
>>>> On 14/11/14 03:27, Andy Yan wrote:
>>>>> hdmi phy clock symbol and transmission termination value
>>>>> can adjust platform specific to get the best SI
>>>>                          ^Is this signal integrity?
>>>     yes , SI  is signal integrity, such as eye diagram measurement
>>>> Are these two disjoint features in separate patches?
>>>>
>>>>> also add mode_valid interface for some platform may not support
>>>>> all the display mode
>>>> Sounds like another separate patch to me. :)
>>>     they can seperate
>>>> Also, This series is becoming quite large. With major changes and fixes mixed together.
>>>>
>>>> Patch 3 splits imx-drm.
>>>> Patch 4 moves dw-drm out of imx-drm folder.
>>>> Patch 7 adds binding
>>>> Patch 9 converts to drm bridge.
>>>>
>>>> Can these be placed together easily?
>>>> And in the start. i.e. patch 1, 2, 3, 4,
>>>>
>>>> Then all fixes etc can come afterwards?
>>>>
>>>> It helps when checking histories later as to how a driver was made and how fixes happened.
>>>>
>>>> Especially when file moves happen..
>>>    Do you mean we can rearrange the patch series?
>>>    put patch 3, 4 ,7, 9 together  one bye one
>>>    than followed by the fixes patches  5 ,6, 8, 11 ?
>> Yes. Rearrange so that the split imx-drm/imx-hdmi and conversion to drm-bridge is at the start of the series.
>> Then the rest are bug fixes and feature additions.
>   Can I put patch#1(make checkpatch happy) and patch#2 (defer probe) as the first two patch.
>   Daniel from Google chromium think it's better to put the two slightly changes in the front for easy review.

Sure.

I am not the maintainer. They have to make the final decision.

ZubairLK
