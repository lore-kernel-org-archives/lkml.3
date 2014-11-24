Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146AbaKXJSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:18:36 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:37419 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaKXJSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:18:33 -0500
MIME-Version: 1.0
In-Reply-To: <1416264102-1323-8-git-send-email-abrestic@chromium.org>
References: <1416264102-1323-1-git-send-email-abrestic@chromium.org>
	<1416264102-1323-8-git-send-email-abrestic@chromium.org>
Date: Mon, 24 Nov 2014 14:48:31 +0530
Message-ID: <CAJe_ZheyfmX-bcuqGQk4vKA1DFJYgr69w2B_9rxf3POKHWqYyA@mail.gmail.com>
Subject: Re: [PATCH V5 07/12] pinctrl: tegra-xusb: Add USB PHY support
From: Jassi Brar <jaswinder.singh@linaro.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Olof Johansson <olof@lixom.net>, Rob Herring <robh+dt@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 November 2014 at 04:11, Andrew Bresticker <abrestic@chromium.org> wrote:
> In addition to the PCIe and SATA PHYs, the XUSB pad controller also
> supports 3 UTMI, 2 HSIC, and 2 USB3 PHYs.  Each USB3 PHY uses a single
> PCIe or SATA lane and is mapped to one of the three UTMI ports.
>
> The xHCI controller will also send messages intended for the PHY driver,
> so request and listen for messages on the mailbox's PHY channel.
>
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>

Mailbox bits look good to me.

-Jassi
