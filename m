Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389AbaLIONi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:13:38 -0500
Received: from mail-qg0-f51.google.com ([209.85.192.51]:49646 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002AbaLIONa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:13:30 -0500
MIME-Version: 1.0
In-Reply-To: <1418093554-30671-1-git-send-email-lyz@rock-chips.com>
References: <1418093554-30671-1-git-send-email-lyz@rock-chips.com>
Date: Tue, 9 Dec 2014 15:13:29 +0100
Message-ID: <CABgxDoJ_anqvD215see84RJ2U04kExyouaN1CNUCTYJ9+XMSig@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] ARM: dts: add rk3288 usb PHY
From: Romain Perier <romain.perier@gmail.com>
To: Yunzhi Li <lyz@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Rob Herring <robh+dt@kernel.org>, "pawel.moll" <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-12-09 3:52 GMT+01:00 Yunzhi Li <lyz@rock-chips.com>:
> This patch adds a device_node for RK3288 SoC usb phy. It also
> defines the phy to be used by three usb controllers: usb_host0/1
> and usb_otg.
>
> Signed-off-by: Yunzhi Li <lyz@rock-chips.com>
>
> ---
>

Tiny thing: Could you change your short description to "ARM: dts:
rockchip: add rk3288 usb PHY" ? (as this is the case for all
devicetree related changes for a specific SoC)

Thanks,
Romain
