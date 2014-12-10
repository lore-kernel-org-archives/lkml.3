Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbaLJSWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:22:55 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:38411 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbaLJSWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:22:53 -0500
MIME-Version: 1.0
In-Reply-To: <54882324.10700@rock-chips.com>
References: <1418093001-30443-1-git-send-email-lyz@rock-chips.com>
	<1418093001-30443-2-git-send-email-lyz@rock-chips.com>
	<CABgxDoJRA4cQBqNBTCSGnnLpcOHqqTuBqcyWQosVv4A_Gx315g@mail.gmail.com>
	<54882324.10700@rock-chips.com>
Date: Wed, 10 Dec 2014 19:22:52 +0100
Message-ID: <CABgxDoKgkB2RJH-iKCqY8_wB-9K3qH-PkHNzYD6OdbeVqPt4=g@mail.gmail.com>
Subject: Re: [PATCH v4 1/5] phy: add a driver for the Rockchip SoC internal
 USB2.0 PHY
From: Romain Perier <romain.perier@gmail.com>
To: Yunzhi Li <lyz@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Doug Anderson <dianders@chromium.org>, olof@lixom.net,
        Tao Huang <huangtao@rock-chips.com>, Chris Zhong <zyw@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, linux-rockchip@lists.infradead.org,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> So,do you mean that I should rename the C source file as phy-rockchip-usb2.c
> ?

what I mean is that you can simply rename the kconfig entry to
PHY_ROCKCHIP_USB. If you explain that it is for usb 2.0 in the
description (as it is already the case),
it is enough, no needs to put USB2 in the kconfig entry name :)

Have a nice evening,
Romain
