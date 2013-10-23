Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab3JWRMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 13:12:38 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38220 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3JWRMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 13:12:36 -0400
Message-ID: <52680380.7020204@gmail.com>
Date: Wed, 23 Oct 2013 12:12:32 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Grant Likely <grant.likely@linaro.org>
CC: Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Don't send to devicetree list for "arch/*/boot/dts"
References: <1382534520-15688-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1382534520-15688-1-git-send-email-dianders@chromium.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2013 08:22 AM, Doug Anderson wrote:
> As discussed in the ARM kernel summit, people on the devicetree list
> would no longer like to receive emails about all dts changes.  Remove
> from MAINTAINERS.

We need to make sure platform maintainers are copied though. That may be
hard since we don't have standard layout/naming of dts files.

We might also want to drop these:
K:      of_get_property
K:      of_match_table

They are at least on the wrong maintainer list now as they should be
associated with the binding maintainers and not DT core code if we do
keep them.

Also based on the discussion, we need to add
Documentation/devicetree/bindings/* to appropriate subsystem
maintainers, but that should probably wait until after Friday at least.

Rob

> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  MAINTAINERS | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ebaf8bd..0166e8e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5987,7 +5987,6 @@ OMAP DEVICE TREE SUPPORT
>  M:	Benoît Cousson <bcousson@baylibre.com>
>  M:	Tony Lindgren <tony@atomide.com>
>  L:	linux-omap@vger.kernel.org
> -L:	devicetree@vger.kernel.org
>  S:	Maintained
>  F:	arch/arm/boot/dts/*omap*
>  F:	arch/arm/boot/dts/*am3*
> @@ -6167,7 +6166,6 @@ M:	Ian Campbell <ijc+devicetree@hellion.org.uk>
>  L:	devicetree@vger.kernel.org
>  S:	Maintained
>  F:	Documentation/devicetree/
> -F:	arch/*/boot/dts/
>  F:	include/dt-bindings/
>  
>  OPENRISC ARCHITECTURE
> 

