Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbaIYNJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 09:09:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57754 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaIYNJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 09:09:25 -0400
Message-ID: <1411650539.5671.4.camel@pengutronix.de>
Subject: Re: [PATCH 1/9] ARM: dts: vf610: Add system reset controller (SRC)
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Stefan Agner <stefan@agner.ch>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Alexandre Courbot <gnurou@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        jingchang.lu@freescale.com,
        Huang Yongcai-B20788 <b20788@freescale.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org
Date: Thu, 25 Sep 2014 15:08:59 +0200
In-Reply-To: <45f7af8b2dbe11967bb2ad87826b934c@agner.ch>
References: <cover.1411404079.git.stefan@agner.ch>
	 <2ca1cf3732a00512fa19b6118f9fb30aba014deb.1411404079.git.stefan@agner.ch>
	 <CACRpkdbryJVW9e9N5+f3rWEGZ2YvLPJsvBtNSa9nPJpLVXhm0g@mail.gmail.com>
	 <45f7af8b2dbe11967bb2ad87826b934c@agner.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.6-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

Am Mittwoch, den 24.09.2014, 18:41 +0200 schrieb Stefan Agner:
> Am 2014-09-24 11:16, schrieb Linus Walleij:
> > On Mon, Sep 22, 2014 at 7:09 PM, Stefan Agner <stefan@agner.ch> wrote:
> > 
> >> Add device tree property for system reset controller.
> >>
> >> Signed-off-by: Stefan Agner <stefan@agner.ch>
> > 
> > Are there already device tree bindings for SRC and GRC?
> 
> Yes there are used in the i.MX6 world for instance, see imx6qdl.dtsi.
> The SRC also has quite generic documentation, however, the GPC module
> currently lacks documentation...

A patch that adds GPC binding documentation is part of this i.MX6 power
domain series:

http://www.spinics.net/lists/devicetree/msg48454.html

regards
Philipp

