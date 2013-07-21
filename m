Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab3GUARI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 20:17:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33240 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab3GUARH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 20:17:07 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1374290388-19308-3-git-send-email-grant.likely@linaro.org>
References: <1374290388-19308-1-git-send-email-grant.likely@linaro.org>
	<1374290388-19308-3-git-send-email-grant.likely@linaro.org>
Date: Sat, 20 Jul 2013 17:17:05 -0700
Message-ID: <CAOesGMhaAy93J=Q1STZUHHA-SbH+WXCVuUn0ef14_18du2dk6w@mail.gmail.com>
Subject: Re: [PATCH 3/3] MAINTAINERS: Refactor device tree maintainership
From: Olof Johansson <olof@lixom.net>
To: Grant Likely <grant.likely@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 8:19 PM, Grant Likely <grant.likely@linaro.org> wrote:
> Device tree bindings require a lot more attention than they used to.
> We've got a group of volunteers willing to take over maintaining
> bindings. This patch adds them to the MAINTAINERS file.
>
> This group still needs to work out a process for maintainership and how
> they are going to work together. I recommend that they set up a shared
> tree on git.kernel.org that they each have commit access to similar to
> the tip tree or the arm-soc tree, but it is up to them.
>
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Ian Campbell <ian.campbell@citrix.com>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Olof Johansson <olof@lixom.net>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: devicetree@vger.kernel.org
> ---
>  MAINTAINERS | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bc286e4..12c95d5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6050,13 +6050,24 @@ L:      devicetree@vger.kernel.org
>  W:     http://fdt.secretlab.ca
>  T:     git git://git.secretlab.ca/git/linux-2.6.git
>  S:     Maintained
> -F:     Documentation/devicetree
>  F:     drivers/of
>  F:     include/linux/of*.h
>  F:     scripts/dtc
>  K:     of_get_property
>  K:     of_match_table
>
> +OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS
> +M:     Pawel Moll <pawel.moll@arm.com>
> +M:     Mark Rutland <mark.rutland@arm.com>
> +M:     Stephen Warren <swarren@wwwdotorg.org>
> +M:     Ian Campbell <ian.campbell@citrix.com>
> +L:     devicetree@vger.kernel.org
> +S:     Maintained
> +F:     Documentation/devicetree
> +F:     arch/*/boot/dts
> +F:     arch/*/

This seems a bit broad. Someone is going to get a whole lot of email
if this goes in, and it might confuse contributors on who is
maintainer of what under arch.


-Olof
