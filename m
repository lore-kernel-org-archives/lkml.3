Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaKXJZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:25:24 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:44802 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbaKXJZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:25:20 -0500
MIME-Version: 1.0
In-Reply-To: <1416264102-1323-5-git-send-email-abrestic@chromium.org>
References: <1416264102-1323-1-git-send-email-abrestic@chromium.org>
	<1416264102-1323-5-git-send-email-abrestic@chromium.org>
Date: Mon, 24 Nov 2014 14:55:19 +0530
Message-ID: <CAJe_ZhdBs-whcxUyQ0kqenVOKcXub77=k9deNP5z8AypoWCsGA@mail.gmail.com>
Subject: Re: [PATCH V5 04/12] of: Add NVIDIA Tegra XUSB mailbox binding
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
> Add device-tree bindings for the Tegra XUSB mailbox which will be used
> for communication between the Tegra xHCI controller's firmware and the
> host processor.
>
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>

Acked-by: Jassi Brar <jaswinder.singh@linaro.org>
