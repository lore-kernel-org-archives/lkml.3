Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbaKXOfy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:35:54 -0500
Received: from lucky1.263xmail.com ([211.157.147.133]:54517 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184AbaKXOfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:52 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: l.stach@pengutronix.de
X-SENDER-IP: 121.15.173.1
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <55a1a7481edddcf4f6dd407468005e5d>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <54734240.8070402@rock-chips.com>
Date: Mon, 24 Nov 2014 22:35:44 +0800
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
Subject: Re: [PATCH v12 0/11] dw-hdmi: convert imx hdmi to bridge/dw_hdmi
References: <1415793593-5075-1-git-send-email-andy.yan@rock-chips.com> <1416221635-12797-1-git-send-email-andy.yan@rock-chips.com> <54733DF3.7020609@rock-chips.com> <54733F34.5080405@imgtec.com>
In-Reply-To: <54733F34.5080405@imgtec.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ZubairLK:
On 2014年11月24日 22:22, Zubair Lutfullah Kakakhel wrote:
> Hi Andy,
>
> On 24/11/14 14:17, Andy Yan wrote:
>> Hi ZubairLK, Russel King, Greg Kroah-Hartman , Philipp Zabel and Daniel:
>>     Do you have any further opinions or suggestions about the
>> the current patch set?
> I have reviewed the patches as much as I could.
>
> They look good to me.
>
> But I don't know the inner details of DRM to be able to comment further.
>
> Please do cc me in further patches.

  Thanks very much for your carefully review work.
  And if you have further ideas , please let me know.
>
> Also, my mail client makes these patches look like the new series gets cascaded in the older patch 8 series.
>
> It could be just my thunderbird. But please start a new thread when you send a new series.

    I do these by taking Russell King's advice in PATCH#10(use the same 
reference message id).

>
> Thank-you
> ZubairLK
>
>> On 2014年11月17日 18:53, Andy Yan wrote:
>>> We found Freescale imx6 and Rockchip rk3288 and Ingenic JZ4780 (Xburst/MIPS)
>>> use the interface compatible Designware HDMI IP, but they also have some
>>> lightly differences, such as phy pll configuration, register width(imx hdmi
>>> register is one byte, but rk3288 is 4 bytes width and can only be accessed
>>> by word), 4K support(imx6 doesn't support 4k, but rk3288 does), and HDMI2.0
>>> support.
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip


