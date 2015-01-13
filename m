Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbbAMPQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:16:03 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:37380 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751145AbbAMPQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:16:00 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v3 0/2] ARM: mediatek: Add driver for Mediatek I2C
 controller
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>, <linux-i2c@vger.kernel.org>,
        Jean Delvare <jdelvare@suse.de>,
        Xudong Chen <xudong.chen@mediatek.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        YH Chen <yh.chen@mediatek.com>, Liguo Zhang <Liguo.Zhang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        <linux-arm-kernel@lists.infradead.org>, <srv_heupstream@mediatek.com>,
        <linux-kernel@vger.kernel.org>, Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20150113095725.GC1059@katana>
References: <1416821928-11453-1-git-send-email-xudong.chen@mediatek.com>
	 <20141124121555.GG3733@katana> <1417096856.12707.59.camel@mtksdaap41>
	 <20141127164536.GC5667@katana> <1418352022.4994.44.camel@mtksdaap41>
	 <20150106133753.GA3754@katana>  <20150113095725.GC1059@katana>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jan 2015 23:15:54 +0800
Message-ID: <1421162154.27675.75.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-13 at 10:57 +0100, Wolfram Sang wrote:
> On Tue, Jan 06, 2015 at 02:37:53PM +0100, Wolfram Sang wrote:
> > 
> > > We've started upstream work for MT8173[1].
> > > 
> > > We've fixed these issues for new SoC, and we believe it is fully I2C
> > > compatible now. We'll add mt8173 support to this driver, so this driver
> > > will support both fully I2C compatible SoC and the current one.
> > 
> > From what you tell, I'd rather add the MT8173 support incrementally.
> > Let's get first the limited support properly implemented, then add
> > another controller.
> > 
> > I'll send out my draft for describing the quirks later today.
> 
> What do you think about my two proposals?

I think the quirks can describe our HW limitation without issue.
We are porting our i2c driver base on that. Will let you know the test
result.
Thanks

Joe.C



