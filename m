Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbaFYVzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 17:55:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55566 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585AbaFYVzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 17:55:01 -0400
Message-ID: <53AB4530.2050106@wwwdotorg.org>
Date: Wed, 25 Jun 2014 15:54:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v1 5/9] of: Add NVIDIA Tegra XHCI controller binding
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org> <1403072180-4944-6-git-send-email-abrestic@chromium.org>
In-Reply-To: <1403072180-4944-6-git-send-email-abrestic@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2014 12:16 AM, Andrew Bresticker wrote:
> Add device-tree binding documentation for the XHCI controller present
> on Tegra124 and later SoCs.

> diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt b/Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt

> + - clock-names: Must include the following entries:
> +    - xusb_host
> +    - xusb_falcon_src
> +    - xusb_ss
> +    - xusb_ss_src
> +    - xusb_hs_src
> +    - xusb_fs_src

Looking at include/dt-bindings/clock/tegra124-car.h I see a few entries
potentially missing here:

#define TEGRA124_CLK_XUSB_HOST_SRC 252
#define TEGRA124_CLK_XUSB_DEV_SRC 256
#define TEGRA124_CLK_XUSB_DEV 257
#define TEGRA124_CLK_XUSB_SS_DIV2 312

> +    - pll_u_480m

Not just pll_u?
