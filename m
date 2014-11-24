Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbaKXOXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:23:17 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:45428 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbaKXOXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:23:15 -0500
Message-ID: <54733F34.5080405@imgtec.com>
Date: Mon, 24 Nov 2014 14:22:44 +0000
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andy Yan <andy.yan@rock-chips.com>, <airlied@linux.ie>, <heiko@sntech.de>,
        <fabio.estevam@freescale.com>, <rmk+kernel@arm.linux.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Josh Boyer <jwboyer@redhat.com>,
        Sean Paul <seanpaul@chromium.org>, Inki Dae <inki.dae@samsung.com>,
        Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Lucas Stach <l.stach@pengutronix.de>, <djkurtz@google.com>,
        <ykk@rock-chips.com>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <devel@driverdev.osuosl.org>,
        <devicetree@vger.kernel.org>, <linux-rockchip@lists.infradead.org>,
        <jay.xu@rock-chips.com>, Pawel Moll <pawel.moll@arm.com>,
        <mark.yao@rock-chips.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v12 0/11] dw-hdmi: convert imx hdmi to bridge/dw_hdmi
References: <1415793593-5075-1-git-send-email-andy.yan@rock-chips.com> <1416221635-12797-1-git-send-email-andy.yan@rock-chips.com> <54733DF3.7020609@rock-chips.com>
In-Reply-To: <54733DF3.7020609@rock-chips.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On 24/11/14 14:17, Andy Yan wrote:
> Hi ZubairLK, Russel King, Greg Kroah-Hartman , Philipp Zabel and Daniel:
>    Do you have any further opinions or suggestions about the
> the current patch set?

I have reviewed the patches as much as I could.

They look good to me.

But I don't know the inner details of DRM to be able to comment further.

Please do cc me in further patches.

Also, my mail client makes these patches look like the new series gets cascaded in the older patch 8 series.

It could be just my thunderbird. But please start a new thread when you send a new series.

Thank-you
ZubairLK

> On 2014年11月17日 18:53, Andy Yan wrote:
>> We found Freescale imx6 and Rockchip rk3288 and Ingenic JZ4780 (Xburst/MIPS)
>> use the interface compatible Designware HDMI IP, but they also have some
>> lightly differences, such as phy pll configuration, register width(imx hdmi
>> register is one byte, but rk3288 is 4 bytes width and can only be accessed
>> by word), 4K support(imx6 doesn't support 4k, but rk3288 does), and HDMI2.0
>> support.
