Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbaKGCWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 21:22:07 -0500
Received: from regular1.263xmail.com ([211.150.99.132]:50569 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaKGCWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 21:22:04 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: l.stach@pengutronix.de
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <bec00c5049c7b79050fa847925c19a67>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <545C2CB0.3090901@rock-chips.com>
Date: Fri, 07 Nov 2014 10:21:36 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, Zubair.Kakakhel@imgtec.com,
        Arnd Bergmann <arnd@arndb.de>, Josh Boyer <jwboyer@redhat.com>,
        ykk@rock-chips.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Inki Dae <inki.dae@samsung.com>,
        linux-rockchip@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Sean Paul <seanpaul@chromium.org>, djkurtz@google.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Dave Airlie <airlied@redhat.com>,
        Grant Likely <grant.likely@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>, jay.xu@rock-chips.com,
        Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH V3 4/4] dw-hdmi: convert dw-hdmi to drm_bridge mode
References: <1415273118-57045-1-git-send-email-andy.yan@rock-chips.com> <1415273176-57096-1-git-send-email-andy.yan@rock-chips.com> <20141106155410.GB19811@kroah.com>
In-Reply-To: <20141106155410.GB19811@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014年11月06日 23:54, Greg Kroah-Hartman wrote:
> On Thu, Nov 06, 2014 at 07:26:16PM +0800, Andy Yan wrote:
>> From: ykk <ykk@rock-chips.com>
> We need a "real" name here, sorry.
>
>> dw-hdmi is under drm/bridge, so it should be the bridge mode.
>> hange off the encoder to dw_hdmi-imx.c, keep the connector &
>> birdge in dw_hdmi.c
>>
>> Signed-off-by: ykk <ykk@rock-chips.com>
> Same here.
>
> thanks,
>
> greg k-h
>
>
>
Sorry, these will be fixed in V4. And tks for you pointing it out.

