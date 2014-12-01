Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbaLAU0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 15:26:31 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:63966 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191AbaLAU03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 15:26:29 -0500
Date: Mon, 1 Dec 2014 21:26:21 +0100 (CET)
From: Stefan Wahren <stefan.wahren@i2se.com>
Reply-To: Stefan Wahren <stefan.wahren@i2se.com>
To: linux@arm.linux.org.uk, robh+dt@kernel.org,
        Jianqun Xu <jay.xu@rock-chips.com>, heiko@sntech.de,
        grant.likely@linaro.org
Cc: linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Message-ID: <798888970.2970.1417465581078.JavaMail.open-xchange@oxbaltgw06.schlund.de>
In-Reply-To: <1417419281-9243-1-git-send-email-jay.xu@rock-chips.com>
References: <1417419281-9243-1-git-send-email-jay.xu@rock-chips.com>
Subject: Re: [PATCH 0/2] rockchip: efuse: add driver to support rk3288 efuse
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.6.0-Rev32
X-Originating-Client: com.openexchange.ox.gui.dhtml
X-Provags-ID: V02:K0:sVwiNNOA4UCsGXl6/WEnHjrBGhGiIwiyO6IDoQNIPck
 NXbP25LHWcLZVFMEz5xWcz0XCbwhIxKb2D0Z/zDDnGL0wax580
 lBd3v0cAb7OIkHzH8O3IqRY1mkMJCYr+shb1XUxwpd7rPjsw/r
 q7ZreomAYVkc2IXF88vY2znAmArdgXf/X7eh0+KQ7lYX1UUlR3
 1tKUVCH75ba2WiS5OcSOMQRWvXytzn23FdtAuRFwQDswwKOQ90
 M2RKDrm2vIJxWCI2vsFVwLgKrHyZ/KVdQXNMXuYk3aJf/sJMXY
 OJh+3dLOuWCuIrH1Y2lzsBqiYPnVlsh8bzxrNqJEXQtkiAaiMg
 SeOoh4xgZRhxJj9la65ISq9UQbAynEJBwHngYyVk8uEX337zfv
 6rjz0LPd8g+1TLug97mQGQf4zjOasIC3/YJ3EBuTFkOsrbtttY
 H+qKd
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jianqun,

> Jianqun Xu <jay.xu@rock-chips.com> hat am 1. Dezember 2014 um 08:34
> geschrieben:
>
>
> In RK3288, there are two eFuse. One is organized as 32bits by 8 one-time
> programmable electrical fuses with random access interface, and the other
> is organized as 32bits by 32 one-time programmable electrical fuses.
>
> Jianqun Xu (2):
> rockchip: efuse: add documentation for rk3288 efuse driver
> rockchip: efuse: add efuse driver for rk3288 efuse
>
> .../bindings/fuse/rockchip,rk3288-efuse.txt | 14 ++
> arch/arm/mach-rockchip/efuse.c | 165 +++++++++++++++++++++
> arch/arm/mach-rockchip/efuse.h | 15 ++

is it possible that you forgot Kconfig and Makefile?

Stefan
