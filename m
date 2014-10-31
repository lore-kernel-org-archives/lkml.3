Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbaJaJoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 05:44:44 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:39707 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544AbaJaJom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 05:44:42 -0400
MIME-Version: 1.0
In-Reply-To: <1414535277-15645-4-git-send-email-abrestic@chromium.org>
References: <1414535277-15645-1-git-send-email-abrestic@chromium.org>
	<1414535277-15645-4-git-send-email-abrestic@chromium.org>
Date: Fri, 31 Oct 2014 10:44:41 +0100
Message-ID: <CACRpkdbERA6rxrMTJQPGaNhAb=B3+KyQ1YBKNy2AqsLZD2eHDA@mail.gmail.com>
Subject: Re: [PATCH RESEND V4 3/9] of: Update Tegra XUSB pad controller
 binding for USB
From: Linus Walleij <linus.walleij@linaro.org>
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 11:27 PM, Andrew Bresticker
<abrestic@chromium.org> wrote:

> Add new bindings used for USB support by the Tegra XUSB pad controller.
> This includes additional PHY types, USB-specific pinconfig properties, etc.
>
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> Reviewed-by: Stephen Warren <swarren@nvidia.com>
> ---
> Changes from v2:
>  - Added nvidia,otg-hs-curr-level-offset property.
>  - Dropped "-otg" from VBUS supplies.
>  - Added mbox-names property.
>  - Removed extra whitespace.
> Changes from v1:
>  - Updated to use common mailbox bindings.
>  - Made USB3 port-to-lane mappins a top-level binding rather than a pinconfig
>    binding.
>  - Add #defines for the padctl lanes.

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I guess you will take this patch along with the rest through ARM SoC
or so?

Yours.
Linus Walleij
