Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3AYISC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 03:18:02 -0500
Received: from mail-ia0-f173.google.com ([209.85.210.173]:37057 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3AYIR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 03:17:58 -0500
MIME-Version: 1.0
In-Reply-To: <1358889025-8530-4-git-send-email-gregory.clement@free-electrons.com>
References: <1358889025-8530-1-git-send-email-gregory.clement@free-electrons.com>
	<1358889025-8530-4-git-send-email-gregory.clement@free-electrons.com>
Date: Fri, 25 Jan 2013 09:17:57 +0100
Message-ID: <CACRpkdbBOQ_KE001kfORapo9=WiJYn04MmRhxnn-5v8ki-EeyA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] arm: mvebu: enable gpio expander over i2c on
 Mirabox platform
From: Linus Walleij <linus.walleij@linaro.org>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Roland Stigge <stigge@antcom.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 10:10 PM, Gregory CLEMENT
<gregory.clement@free-electrons.com> wrote:

> The Globalscale Mirabox platform can be connected to the JTAG/GPIO box
> through the Multi-IO port. The GPIO box use the NXP PCA9505 I/O port
> expansion IC to provide 40-bit parallel input/output GPIOs. This patch
> enable the use of this expander on the Mirabox.
>
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

So as requested I leave this patch for now, tell me if you want it
applied through pinctrl.

Yours,
Linus Walleij
