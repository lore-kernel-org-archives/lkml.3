Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592AbaIILn2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:43:28 -0400
Received: from gloria.sntech.de ([95.129.55.99]:47993 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640AbaIILn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:43:27 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Chris Zhong <zyw@rock-chips.com>
Cc: dianders@chromium.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, sameo@linux.intel.com, lee.jones@linaro.org,
        lgirdwood@gmail.com, a.zummo@towertech.it, mturquette@linaro.org,
        akpm@linux-foundation.org, broonie@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com, grant.likely@linaro.org, hl@rock-chips.com,
        huangtao@rock-chips.com, cf@rock-chips.com, zhangqing@rock-chips.com,
        xxx@rock-chips.com, olof@lixom.net, sonnyrao@chromium.org,
        dtor@chromium.org, javier.martinez@collabora.co.uk,
        kever.yang@rock-chips.com
Subject: Re: [PATCH v9 0/3] Add rockchip RK808 pmic driver
Date: Tue, 09 Sep 2014 13:45:24 +0200
Message-ID: <6686857.xs1HS8QUx8@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1409793159-2573-1-git-send-email-zyw@rock-chips.com>
References: <1409793159-2573-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Am Donnerstag, 4. September 2014, 09:12:36 schrieb Chris Zhong:
> This is the initial version of the RK808 PMIC. This is a power management IC
> for multimedia products.
> 
> It provides regulators that are able to supply power to processor cores
> and other components. The chip provides other modules including RTC,
> Clockout


> Chris Zhong (3):
>   RTC: RK808: add RTC driver for RK808
>   clk: RK808: Add clkout driver for RK808
>   regulator: RK808: Remove pdata from the regulator

It looks like the rk808 driver that is currently in the regulator tree [0] is 
producing compile errors. After applying your regulator patch from this series 
it again compiles - and works.

So could you try to fast track this please? If you're short on time you could 
also just fix the small comment you received for patch3 and send it alone 
without the first two.


Heiko


[0] 
https://git.kernel.org/cgit/linux/kernel/git/broonie/regulator.git/log/?h=topic/rk808
