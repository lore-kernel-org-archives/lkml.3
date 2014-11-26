Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaKZC3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 21:29:31 -0500
Received: from lucky1.263xmail.com ([211.157.147.133]:47894 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbaKZC33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 21:29:29 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: l.stach@pengutronix.de
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <a5b659ec67dafee31836d86ecfa9ade3>
X-DNS-TYPE: 0
Message-ID: <54753AF8.1060803@rock-chips.com>
Date: Wed, 26 Nov 2014 10:29:12 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: David Airlie <airlied@linux.ie>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>, ykk@rock-chips.com,
        devel@driverdev.osuosl.org, Arnd Bergmann <arnd@arndb.de>,
        linux-rockchip@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Dave Airlie <airlied@redhat.com>, jay.xu@rock-chips.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Zubair.Kakakhel@imgtec.com, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Inki Dae <inki.dae@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Sean Paul <seanpaul@chromium.org>, mark.yao@rock-chips.com,
        Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, djkurtz@google.com,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>, Shawn Guo <shawn.guo@linaro.org>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v12 0/11] dw-hdmi: convert imx hdmi to bridge/dw_hdmi
References: <1415793593-5075-1-git-send-email-andy.yan@rock-chips.com>	<1416221635-12797-1-git-send-email-andy.yan@rock-chips.com> <CAOMZO5BH0TwOk3aFeabAqE+JssG9YL=CsTz2Tq3Q1L46fTbcCQ@mail.gmail.com>
In-Reply-To: <CAOMZO5BH0TwOk3aFeabAqE+JssG9YL=CsTz2Tq3Q1L46fTbcCQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio:

On 2014年11月26日 10:14, Fabio Estevam wrote:
> Hi Andy,
>
> On Mon, Nov 17, 2014 at 8:53 AM, Andy Yan <andy.yan@rock-chips.com> wrote:
>
>> Andy Yan (11):
>>    staging: imx-drm: imx-hdmi: make checkpatch happy
>>    staging: imx-drm: imx-hdmi: return defer if can't get ddc i2c adapter
>>    staging: imx-drm: imx-hdmi: convert imx-hdmi to drm_bridge mode
>>    staging: imx-drm: imx-hdmi: move imx-hdmi to bridge/dw_hdmi
> imx-drm has moved out of staging.
>
> Please see Phillip's patch:
> http://cgit.freedesktop.org/~airlied/linux/commit/?h=drm-next&id=6556f7f82b9c401950d703072c0d8137b6f9f516
>
> So you need to re-submit your series against drm-next.
>
>
   Thanks very much for you pointing out this, I will re-submit my 
patch  set against drm-next  soon.


