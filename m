Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaLENrp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:47:45 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:53203 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaLENro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:47:44 -0500
MIME-Version: 1.0
In-Reply-To: <1417783941-2418-5-git-send-email-lyz@rock-chips.com>
References: <1417783941-2418-1-git-send-email-lyz@rock-chips.com>
	<1417783941-2418-5-git-send-email-lyz@rock-chips.com>
Date: Fri, 5 Dec 2014 14:47:43 +0100
Message-ID: <CABgxDoKXdvWX1vWK78VntuJ5Eo29hyYQCBmOZGYEDZAWg0xjGA@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ARM: dts: add rk3288 usb PHY
From: Romain Perier <romain.perier@gmail.com>
To: Yunzhi Li <lyz@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Doug Anderson <dianders@chromium.org>,
        Tao Huang <huangtao@rock-chips.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        linux-rockchip@lists.infradead.org,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        zyw@rock-chips.com, devicetree <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        olof@lixom.net, Eddie Cai <cf@rock-chips.com>,
        ulrich.prinz@googlemail.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-12-05 13:52 GMT+01:00 Yunzhi Li <lyz@rock-chips.com>:
> Add dt nodes for rk3288 usb PHY.

Could you give more context about the changes in the long description ?
Usually, you need a short and a long description for a commit.

For example:

short: "ARM: dts: rockchip: add rk3288 usb PHY"
long: "This patch adds a device_node phy usb for RK3288 SoC. It also
defines the phy to be used by usbhost and usbotg"



Romain
