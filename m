Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965322AbaKNKxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 05:53:17 -0500
Received: from regular1.263xmail.com ([211.150.99.133]:54828 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965238AbaKNKxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 05:53:13 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: l.stach@pengutronix.de
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <86d64fe61f6d7613653ed283e5b0ef45>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5465DF0C.50301@rock-chips.com>
Date: Fri, 14 Nov 2014 18:53:00 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>, airlied@linux.ie,
        heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk
CC: Mark Rutland <mark.rutland@arm.com>, dri-devel@lists.freedesktop.org,
        ykk@rock-chips.com, devel@driverdev.osuosl.org,
        Arnd Bergmann <arnd@arndb.de>, linux-rockchip@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Dave Airlie <airlied@redhat.com>, jay.xu@rock-chips.com,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Sean Paul <seanpaul@chromium.org>, mark.yao@rock-chips.com,
        Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, djkurtz@google.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v10 05/11] drm: bridge/dw_hdmi:split some phy configuration
 to platform driver
References: <1415934583-16290-1-git-send-email-andy.yan@rock-chips.com> <1415935631-16826-1-git-send-email-andy.yan@rock-chips.com> <5465D73C.9030507@imgtec.com>
In-Reply-To: <5465D73C.9030507@imgtec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ZubairLK:
    Thanks for your review.
On 2014年11月14日 18:19, Zubair Lutfullah Kakakhel wrote:
> Hi Andy,
>
> Nice work on this patch series. Its getting better and better :).
>
> On 14/11/14 03:27, Andy Yan wrote:
>> hdmi phy clock symbol and transmission termination value
>> can adjust platform specific to get the best SI
> 						^Is this signal integrity?
    yes , SI  is signal integrity, such as eye diagram measurement
>
> Are these two disjoint features in separate patches?
>
>> also add mode_valid interface for some platform may not support
>> all the display mode
> Sounds like another separate patch to me. :)
    they can seperate
>
> Also, This series is becoming quite large. With major changes and fixes mixed together.
>
> Patch 3 splits imx-drm.
> Patch 4 moves dw-drm out of imx-drm folder.
> Patch 7 adds binding
> Patch 9 converts to drm bridge.
>
> Can these be placed together easily?
> And in the start. i.e. patch 1, 2, 3, 4,
>
> Then all fixes etc can come afterwards?
>
> It helps when checking histories later as to how a driver was made and how fixes happened.
>
> Especially when file moves happen..
   Do you mean we can rearrange the patch series?
   put patch 3, 4 ,7, 9 together  one bye one
   than followed by the fixes patches  5 ,6, 8, 11 ?
>
> Cheers,
> ZubairLK
>
>> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
>>
>> ---
>>
>> Changes in v10:
>> - split generic dw_hdmi.c improvements from patch#11 (add rk3288 support)
>>
>> Changes in v9: None
>> Changes in v8: None
>> Changes in v7: None
>> Changes in v6: None
>> Changes in v5: None
>> Changes in v4: None
>> Changes in v3: None
>> Changes in v2: None
>>
>>   drivers/gpu/drm/bridge/dw_hdmi.c      | 29 +++++++++++++++++++++++++++--
>>   drivers/staging/imx-drm/dw_hdmi-imx.c | 10 +++++++++-
>>   include/drm/bridge/dw_hdmi.h          |  7 +++++++
>>   3 files changed, 43 insertions(+), 3 deletions(-)
>>
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip
>
>
>


