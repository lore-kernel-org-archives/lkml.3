Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884AbaLLCka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 21:40:30 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:37037 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756958AbaLLCk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 21:40:27 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v3 0/2] ARM: mediatek: Add driver for Mediatek I2C
 controller
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: Liguo Zhang <Liguo.Zhang@mediatek.com>,
        Xudong Chen <xudong.chen@mediatek.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        <srv_heupstream@mediatek.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        YH Chen <yh.chen@mediatek.com>, <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Jean Delvare <jdelvare@suse.de>, <linux-i2c@vger.kernel.org>
In-Reply-To: <20141127164536.GC5667@katana>
References: <1416821928-11453-1-git-send-email-xudong.chen@mediatek.com>
	 <20141124121555.GG3733@katana> <1417096856.12707.59.camel@mtksdaap41>
	 <20141127164536.GC5667@katana>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Dec 2014 10:40:22 +0800
Message-ID: <1418352022.4994.44.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-27 at 17:45 +0100, Wolfram Sang wrote:
> > > I think there are now 3 drivers in my queue which are not fully I2C
> > > compatible but more supporting the very minimum to, say, read an eeprom.
> > > I am not feeling well to allow them to use I2C_FUNC_I2C. So, I want to
> > > think about ways how to communicate deficiencies like "only 255 byte" or
> > > "only WRRD messages" to users of that I2C controller. This is most
> > > likely not happening before 3.19. But assistance is very welcome.

Hi Wolfram,

We've started upstream work for MT8173[1].

We've fixed these issues for new SoC, and we believe it is fully I2C
compatible now. We'll add mt8173 support to this driver, so this driver
will support both fully I2C compatible SoC and the current one.

Joe.C

[1]
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/309847.html





