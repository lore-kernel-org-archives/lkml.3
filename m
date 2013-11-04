Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab3KDM0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 07:26:53 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:59616 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab3KDM0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 07:26:50 -0500
X-AuditID: cbfec7f4-b7f0a6d000007b1b-32-52779288ec40
From: Tomasz Figa <t.figa@samsung.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, gregkh@linuxfoundation.org,
        kgene.kim@samsung.com, k.debski@samsung.com, s.nawrocki@samsung.com,
        balbi@ti.com, jwerner@chromium.org, jg1.han@samsung.com
Subject: Re: [PATCH RFC 1/4] phy: Add new Exynos5 USB 3.0 PHY driver
Date: Mon, 04 Nov 2013 13:26:44 +0100
Message-id: <1539581.zprt32081v@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.2 (Linux/3.11.5-gentoo; KDE/4.11.2; x86_64; ; )
In-reply-to: <527744B2.4090303@ti.com>
References: <1383205544-32244-1-git-send-email-gautam.vivek@samsung.com>
 <1383205544-32244-2-git-send-email-gautam.vivek@samsung.com>
 <527744B2.4090303@ti.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsVy+t/xq7odk8qDDKa8FLc4eL/eYv6Rc6wW
	bVcOsls0L17PZnF54SVWi45Dj5ksfry+wGbRu+Aqm8WFpz1sFpseX2O1WNi2hMXi8q45bBYz
	zu9jsli0rJXZ4vCbdlYHfo/ZDRdZPPbPXcPusXlJvUffllWMHsdvbGfy+LxJLoAtissmJTUn
	syy1SN8ugStj1Y1d7AWL2St6H39mbGC8ztrFyMkhIWAisf5TBzuELSZx4d56ti5GLg4hgaWM
	Ei1bnzBBOF1MEndezAGrYhNQk/jc8IgNxBYR0JI4vfMHM0gRs0AHs8Sbf5eZQBLCAi4Sjdsv
	MYLYLAKqEl2HN7J0MXJw8ApoSjz8Vw4S5hdQl3i37SlYuaiAm8T0HweZQWxOoPlvdy+AWryY
	UaL5+huwU3kFBCV+TL7HAmIzC8hL7Ns/lRXC1pJYv/M40wRGwVlIymYhKZuFpGwBI/MqRtHU
	0uSC4qT0XEO94sTc4tK8dL3k/NxNjJC4+rKDcfExq0OMAhyMSjy8hVfLgoRYE8uKK3MPMUpw
	MCuJ8K4oKg8S4k1JrKxKLcqPLyrNSS0+xMjEwSnVwCi4V9/p54VVYmzL+riyXk/tSF57ftpM
	ns48xTid6ZX11Q+Sv30/O1to+rv2NTNMJ17YfPpl/X8Hl2v2liXbnXbIR1gp3hDjmtwuHdxS
	4jL7W2V+xfPrHXcdp3FvftBZK/viv7yvx9ePmTxqekEd0/5OepSnvNCu82bQrQ5Hj+lv0oXX
	X56x0kCJpTgj0VCLuag4EQD90dU7iQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On Monday 04 of November 2013 12:24:42 Kishon Vijay Abraham I wrote:
> Hi Vivek,
> 
> On Thursday 31 October 2013 01:15 PM, Vivek Gautam wrote:
> > Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
> > The new driver uses the generic PHY framework and will interact
> > with DWC3 controller present on Exynos5 series of SoCs.
> 
> In Exynos, you have a single IP that supports both USB3 and USB2 PHY 
> right? I think that needs to be mentioned here.

Nope. There are two separate, different IPs.

> Do you have separate registers that should be used for 
> initializing/powerin_on/powering_off etc.. for usb2 phy and usb3 phy? If 
> so, then you should model this driver as a single driver that supports 
> two PHYs similar to what Sylwester has done before?

Sylwester's MIPI PHY uses such model because it has a single register
that controls both PHYs.

Best regards,
Tomasz

