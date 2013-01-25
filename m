Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab3AYMzI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 07:55:08 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:55958 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841Ab3AYMzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 07:55:04 -0500
MIME-Version: 1.0
In-Reply-To: <20130125124659.GH1758@titan.lakedaemon.net>
References: <1358889025-8530-1-git-send-email-gregory.clement@free-electrons.com>
	<1358889025-8530-4-git-send-email-gregory.clement@free-electrons.com>
	<CACRpkdbBOQ_KE001kfORapo9=WiJYn04MmRhxnn-5v8ki-EeyA@mail.gmail.com>
	<20130125124659.GH1758@titan.lakedaemon.net>
Date: Fri, 25 Jan 2013 13:55:04 +0100
Message-ID: <CACRpkdZBcAK+9zYSJ2jQhOxNMF-BbO1-5FsRLoJRHH5X9M09VQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] arm: mvebu: enable gpio expander over i2c on
 Mirabox platform
From: Linus Walleij <linus.walleij@linaro.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Roland Stigge <stigge@antcom.de>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 1:46 PM, Jason Cooper <jason@lakedaemon.net> wrote:
> On Fri, Jan 25, 2013 at 09:17:57AM +0100, Linus Walleij wrote:
>> On Tue, Jan 22, 2013 at 10:10 PM, Gregory CLEMENT
>> <gregory.clement@free-electrons.com> wrote:
>>
>> > The Globalscale Mirabox platform can be connected to the JTAG/GPIO box
>> > through the Multi-IO port. The GPIO box use the NXP PCA9505 I/O port
>> > expansion IC to provide 40-bit parallel input/output GPIOs. This patch
>> > enable the use of this expander on the Mirabox.
>> >
>> > Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>> > Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> So as requested I leave this patch for now, tell me if you want it
>> applied through pinctrl.
>
> Which branch did you put the first two on?  I'm not seeing them.

Not pushed yet, take it easy.

Yours,
Linus Walleij
