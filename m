Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab3LMOXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:23:47 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36634 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab3LMOXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:23:46 -0500
Date: Fri, 13 Dec 2013 09:23:41 -0500
From: Matt Porter <mporter@linaro.org>
To: Marc Carino <marc.ceeeee@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Christian Daudt <bcm@fixthebug.org>,
        Arnd Bergmann <arnd@arndb.de>, Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] ARM: brcmstb: add misc. DT bindings for
 brcm,brcmstb
Message-ID: <20131213142341.GB23499@beef>
References: <1385511748-27869-1-git-send-email-marc.ceeeee@gmail.com>
 <1385511748-27869-5-git-send-email-marc.ceeeee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385511748-27869-5-git-send-email-marc.ceeeee@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 04:22:26PM -0800, Marc Carino wrote:
> Document the bindings that the Broadcom STB platform needs
> for proper bootup.
> 
> Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../devicetree/bindings/arm/brcm-brcmstb.txt       |   72 ++++++++++++++++++++
>  1 files changed, 72 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/brcm-brcmstb.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/brcm-brcmstb.txt b/Documentation/devicetree/bindings/arm/brcm-brcmstb.txt
> new file mode 100644
> index 0000000..2f3cd50
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/brcm-brcmstb.txt
> @@ -0,0 +1,72 @@
> +Broadcom STB platforms Device Tree Bindings
> +-------------------------------------------
> +Boards with Broadcom Brahma15-based BCM7xxx SOC shall have the following
> +properties.

Does Brahma15 identify the ARM-based members of the BCM7xxx family? I
ask since it's a little confusing knowing that there's some MIPs-based
BCM7xxx SoCs and this binding is specific to the ARM versions.  Could the
ARM-based members be enumerated explicitly by part number? e.g. BCM7445,
etc.

> +
> +Required root node properties:
> +    - compatible = "brcm,brcmstb";

Along the same lines...Isn't this a little too generic for a compatible
string? If BCM7445 were the first in this family wouldn't brcm,bcm7445
be more appropriate given the compatible string naming guidelines?

-Matt
