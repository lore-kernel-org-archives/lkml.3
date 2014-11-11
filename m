Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbaKKOy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 09:54:58 -0500
Received: from regular1.263xmail.com ([211.150.99.133]:52930 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaKKOuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 09:50:51 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: l.stach@pengutronix.de
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <6f96c344e5ea8173a711bff3d4a63f93>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <54622246.9080302@rock-chips.com>
Date: Tue, 11 Nov 2014 22:50:46 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>, airlied@linux.ie,
        heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk
CC: devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Inki Dae <inki.dae@samsung.com>, linux-rockchip@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>, Sean Paul <seanpaul@chromium.org>,
        djkurtz@google.com, Philipp Zabel <p.zabel@pengutronix.de>,
        ykk@rock-chips.com, Grant Likely <grant.likely@linaro.org>,
        Dave Airlie <airlied@redhat.com>, Shawn Guo <shawn.guo@linaro.org>,
        jay.xu@rock-chips.com, Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v7 6/7] drm: bridge/dw-hdmi: convert dw-hdmi to drm_bridge
 mode
References: <1415710229-11935-1-git-send-email-andy.yan@rock-chips.com> <1415710469-12213-1-git-send-email-andy.yan@rock-chips.com> <54621EF7.4000300@imgtec.com>
In-Reply-To: <54621EF7.4000300@imgtec.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ZubairLK:
On 2014年11月11日 22:36, Zubair Lutfullah Kakakhel wrote:
> Hi Andy,
>
> On 11/11/14 12:54, Andy Yan wrote:
>> From: Yakir Yang <ykk@rock-chips.com>
>>
>> keep the connector & birdge in dw_hdmi.c, handle encoder in dw_hdmi-imx.c
> Is there a reason for this separation? Keeping encoder in platform files?
> If yes, then the commit message should explain that.
    in the encoder, most operation are platform specific, such as
   mux to select which crtc is used,  set panel format etc, these operation
   complete by platform specific interface
>> Signed-off-by: Andy Yan <andy.yan@rock-chips.com>
>> Signed-off-by: Yakir Yang <ykk@rock-chips.com>
>>
>> ---
>>
>> Changes in v7: None
>> Changes in v6:
>> - move some modification from patch#5
>>
>> Changes in v5: None
>> Changes in v4: None
>> Changes in v3: None
>> Changes in v2: None
>>
>>   drivers/gpu/drm/bridge/dw_hdmi.c      | 228 +++++++++++++++-------------------
>>   drivers/staging/imx-drm/dw_hdmi-imx.c | 145 ++++++++++++++-------
>>   include/drm/bridge/dw_hdmi.h          |  13 +-
>>   3 files changed, 199 insertions(+), 187 deletions(-)
>
> Regards
> ZubairLK
>
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip
>
>
>


