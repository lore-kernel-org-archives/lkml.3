Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbaJ2FxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 01:53:11 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:50394 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239AbaJ2FxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 01:53:08 -0400
MIME-Version: 1.0
In-Reply-To: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
References: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Wed, 29 Oct 2014 14:52:45 +0900
Message-ID: <CAAVeFuJ0GhKENAERubGywAHOQp9=iohOxux6O=58xfXNcxG_dg@mail.gmail.com>
Subject: Re: [PATCH RESEND V4 0/9] Tegra xHCI support
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 7:27 AM, Andrew Bresticker
<abrestic@chromium.org> wrote:
> This series adds support for xHCI on NVIDIA Tegra SoCs.  This includes:
>  - patches 1 and 2: adding a driver for the mailbox used to communicate
>    with the xHCI controller's firmware,
>  - patches 3 and 4: extending the XUSB pad controller driver to support
>    the USB PHY types (UTMI, HSIC, and USB3),
>  - patches 5 and 6: adding a xHCI host-controller driver, and
>  - patches 7, 8, and 9: updating the relevant DT files.
>
> The PHY and host drivers have compile-time dependencies on the mailbox
> driver, and the host driver has compile-time dependencies on the PHY
> driver.  It is probably best if these all get merged through the Tegra
> tree.  This series still needs ACKs from the relevant maintainers for
> the mailbox and xHCI host drivers and their device-tree bindings.
>
> Tested on Venice2, Jetson TK1, and Big with a variety of USB2.0 and
> USB3.0 memory sticks and ethernet dongles using controller firmware
> recently posted by Andrew Chew [0].
>
> Based on v3.18-rc2.  All other dependencies (xHCI modules and mailbox
> series) have been merged.

I do not feel comfortable enough with xHCI to give a reviewed-by tag,
but FWIW I have found nothing wrong with these patches.
