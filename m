Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751301AbaLEQcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 11:32:05 -0500
Received: from lucky1.263xmail.com ([211.157.147.132]:40825 "EHLO
	lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaLEQcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 11:32:04 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 1
X-MAIL-DELIVERY: 0
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: andy.yan@rock-chips.com
X-FST-TO: vladimir_zapolskiy@mentor.com
X-SENDER-IP: 210.21.233.66
X-LOGIN-NAME: andy.yan@rock-chips.com
X-UNIQUE-TAG: <f4004c508dc39cedd1731c17355ab840>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <5481DDF2.6010700@rock-chips.com>
Date: Sat, 06 Dec 2014 00:31:46 +0800
From: Andy Yan <andy.yan@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
CC: airlied@linux.ie, heiko@sntech.de, fabio.estevam@freescale.com,
        rmk+kernel@arm.linux.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, Sean Paul <seanpaul@chromium.org>,
        Inki Dae <inki.dae@samsung.com>, Dave Airlie <airlied@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Lucas Stach <l.stach@pengutronix.de>,
        Zubair.Kakakhel@imgtec.com, djkurtz@google.com, ykk@rock-chips.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org, jay.xu@rock-chips.com,
        Pawel Moll <pawel.moll@arm.com>, mark.yao@rock-chips.com,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, vladimir_zapolskiy@mentor.com
Subject: Re: [PATCH v18 0/12] dw-hdmi: convert imx hdmi to bridge/dw_hdmi
References: <1417760564-16858-1-git-send-email-andy.yan@rock-chips.com> <1417787724.3227.10.camel@pengutronix.de>
In-Reply-To: <1417787724.3227.10.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp:
On 2014年12月05日 21:55, Philipp Zabel wrote:
> Hi Andy,
>
> Am Freitag, den 05.12.2014, 14:22 +0800 schrieb Andy Yan:
>> We found Freescale imx6 and Rockchip rk3288 and Ingenic JZ4780 (Xburst/MIPS)
>> use the interface compatible Designware HDMI IP, but they also have some
>> lightly differences, such as phy pll configuration, register width(imx hdmi
>> register is one byte, but rk3288 is 4 bytes width and can only be accessed
>> by word), 4K support(imx6 doesn't support 4k, but rk3288 does), and HDMI2.0
>> support.
>>
>> To reuse the imx-hdmi driver, we make this patch set:
>> (1): fix some CodingStyle warning to make checkpatch happy
>> (2): convert imx-hdmi to drm_bridge
>> (3): split platform specific code
>> (4): move imx-hdmi to bridge/dw_hdmi
>> (5): extend dw_hdmi.c to support rk3288 hdmi
>> (6): add rockchip rk3288 platform specific code dw_hdmi-rockchip.c
>>
>> Changes in v18:
>> - remove a multiple blank lines in imx-hdmi.c
>> - fix a checkpatch warning in imx-hdmi_pltfm.c
>> - add port bindings
>> - correct some spelling mistakes in dw_hdmi bindings doc
>> - correct some spelling mistakes in dw_hdmi-rockchip bindings doc
> [...]
>
> I am happy with the series so far. Pending Acks from the device tree
> maintainers for the new binding documents, I'd like to apply either the
> whole of it on top of
>      git://git.pengutronix.de/git/pza/linux.git imx-drm/next
> or take at least the i.MX specific patches (1-5) because of the
> dependency on the imx-drm OF helper conversion.
>
> regards
> Philipp
>
>
>
>
  I am very glad to see you are happy with the patch set, it's would be 
very
  nice if you can apply all of it.
  Thanks very much for you review.


