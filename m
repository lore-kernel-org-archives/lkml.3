Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704AbaJ3OtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:49:17 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:54526 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760371AbaJ3OtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:49:14 -0400
X-Listener-Flag: 11101
Subject: Re: [PATCH 3/3] I2C: mediatek: Add driver for MediaTek I2C
 controller
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: Matthias Brugger <matthias.bgg@gmail.com>,
        Xudong Chen <xudong.chen@mediatek.com>,
        Mark Rutland <mark.rutland@arm.com>, <arm@kernel.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>, Eddie Huang <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        YH Chen <yh.chen@mediatek.com>
In-Reply-To: <20141030132537.GB23852@katana>
References: <1414561058-23803-1-git-send-email-xudong.chen@mediatek.com>
	 <1414561058-23803-4-git-send-email-xudong.chen@mediatek.com>
	 <CABuKBe+RXboBEZD7Bu_kSbVwiapJJcAuuw_wo=xw67osJWJ20w@mail.gmail.com>
	 <20141030132537.GB23852@katana>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Oct 2014 22:49:05 +0800
Message-ID: <1414680545.5833.21.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-30 at 14:25 +0100, Wolfram Sang wrote:
> > > +obj-$(CONFIG_I2C_MT65XX)       += i2c-mt65xx.o
> > 
> > As it works for mt65xx and mt81xx series, better rename it to i2c-mtk.c
> 
> That is a bit too generic IMO. It is likely that we will see some
> totally different I2C core from MTK in the future. Plus, it is not
> uncommon that a driver initially for SoC-X supports SoC-Y, too.

Hi,

Yes, MTK TV SoCs(MT53xx) do use a different/incompatible I2C IP. So we
preferred to keep original file name.

Joe.C 


