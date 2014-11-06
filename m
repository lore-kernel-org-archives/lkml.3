Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaKFJf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 04:35:56 -0500
Received: from regular2.263xmail.com ([211.157.152.4]:35394 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaKFJfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 04:35:53 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: ykk@rock-chips.com
X-FST-TO: linux@arm.linux.org.uk
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: ykk@rock-chips.com
X-UNIQUE-TAG: <c6370139ece90f168f25ea4537722eb9>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <545B40EC.2030001@rock-chips.com>
Date: Thu, 06 Nov 2014 17:35:40 +0800
From: "Kuankuan.Yang" <ykk@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andy Yan <andy.yan@rock-chips.com>
CC: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Josh Boyer <jwboyer@redhat.com>,
        Sean Paul <seanpaul@chromium.org>, Inki Dae <inki.dae@samsung.com>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Lucas Stach <l.stach@pengutronix.de>, Zubair.Kakakhel@imgtec.com,
        djkurtz@google.com, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH 0/2] make imx hdmi publicly used by dw hdmi compatible
 platform
References: <1415107992-34289-1-git-send-email-andy.yan@rock-chips.com> <20141104142908.GG4042@n2100.arm.linux.org.uk>
In-Reply-To: <20141104142908.GG4042@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell

I'm working on Designware hdmi-audio, also add it as a standard ALSA device.
Before I saw this email, I also planed to submit my patchs to upsteam.
I'm very grateful if you can email those patchs to us.

Best Regards.

于 2014年11月04日 22:29, Russell King - ARM Linux 写道:
> On Tue, Nov 04, 2014 at 09:33:10PM +0800, Andy Yan wrote:
>> From: Andy yan <andy.yan@rock-chips.com>
>>
>> We found freescale imx6 and rockchip rk3288 and Ingenic JZ4780 (Xburst/MIPS)
>> use the interface compatible Designware HDMI IP, but they also have some
>> lightly difference, such as phy pll configuration, register width(imx hdmi
>> register is one byte, but rk3288 is 4 bytes width and can only access by word),
>> 4K support(imx6 doesn't support 4k, but rk3288 does).
>>
>> To reuse the imx-hdmi driver, we do this patch set:
>> patch (1): split out imx-soc code from imx-hdmi to dw_hdmi-imx.c
>> patch (2): move imx-hdmi to bridge/, and rename to dw-hdmi to
>> make this driver indepent of drm-imx . And we will add rockchip
>> platform specific code dw_hdmi-rockchip.c later, this is depend
>> on drm-rockchip.
> Great - I fully agree that this needs to be renamed as it is a Designware
> IP.
>
> Should it be moved into bridge/ ?  It isn't implemented as a DRM bridge
> driver at present, so this seems illogical.  Is the longer term plan to
> convert it to be a DRM bridge?
>
> Secondly, if you want HDMI audio support, you may find the patches I
> maintain for the SolidRun devices useful, which add this as a standard
> ALSA device.  I also have CEC support for it as well.  If you're
> interested, I'll email those.
>


