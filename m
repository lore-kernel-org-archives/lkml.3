Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762715Ab3DCMfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 08:35:31 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:56205 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762394Ab3DCMf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 08:35:28 -0400
MIME-Version: 1.0
In-Reply-To: <1364503606-10597-3-git-send-email-maxime.ripard@free-electrons.com>
References: <1364503606-10597-1-git-send-email-maxime.ripard@free-electrons.com>
	<1364503606-10597-3-git-send-email-maxime.ripard@free-electrons.com>
Date: Wed, 3 Apr 2013 14:35:27 +0200
Message-ID: <CACRpkdapQB7=fem1x8v5nAzitAVMZAe=P4Eroz-wmmK1CQSMgg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: remove mach .init_irq for irqchip_init users
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Alessandro Rubini <rubini@unipv.it>,
        STEricsson <STEricsson_nomadik_linux@list.st.com>,
        Jamie Iles <jamie@jamieiles.com>, Barry Song <baohua.song@csr.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 9:46 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> Now that the arm core code calls irqchip_init, we can remove it from all
> the machines that were using it.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Acked-by: Simon Horman <horms+renesas@verge.net.au>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

For Nomadik.

Yours,
Linus Walleij
