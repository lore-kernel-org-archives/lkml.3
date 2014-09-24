Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbaIXQmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 12:42:13 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:40979 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaIXQmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 12:42:12 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Wed, 24 Sep 2014 18:41:33 +0200
From: Stefan Agner <stefan@agner.ch>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Shawn Guo <shawn.guo@freescale.com>, Sascha Hauer <kernel@pengutronix.de>,
        Alexandre Courbot <gnurou@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        jingchang.lu@freescale.com,
        Huang Yongcai-B20788 <b20788@freescale.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH 1/9] ARM: dts: vf610: Add system reset controller (SRC)
In-Reply-To: <CACRpkdbryJVW9e9N5+f3rWEGZ2YvLPJsvBtNSa9nPJpLVXhm0g@mail.gmail.com>
References: <cover.1411404079.git.stefan@agner.ch>
 <2ca1cf3732a00512fa19b6118f9fb30aba014deb.1411404079.git.stefan@agner.ch>
 <CACRpkdbryJVW9e9N5+f3rWEGZ2YvLPJsvBtNSa9nPJpLVXhm0g@mail.gmail.com>
Message-ID: <45f7af8b2dbe11967bb2ad87826b934c@agner.ch>
User-Agent: Roundcube Webmail/1.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-09-24 11:16, schrieb Linus Walleij:
> On Mon, Sep 22, 2014 at 7:09 PM, Stefan Agner <stefan@agner.ch> wrote:
> 
>> Add device tree property for system reset controller.
>>
>> Signed-off-by: Stefan Agner <stefan@agner.ch>
> 
> Are there already device tree bindings for SRC and GRC?

Yes there are used in the i.MX6 world for instance, see imx6qdl.dtsi.
The SRC also has quite generic documentation, however, the GPC module
currently lacks documentation...

--
Stefan

