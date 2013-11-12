Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab3KLUAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:00:13 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:58025 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237Ab3KLUAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:00:01 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <1384285582-16933-21-git-send-email-eduardo.valentin@ti.com>
References: <1384285582-16933-1-git-send-email-eduardo.valentin@ti.com>
	<1384285582-16933-21-git-send-email-eduardo.valentin@ti.com>
Date: Tue, 12 Nov 2013 11:59:59 -0800
Message-ID: <CAOesGMiCh-nGPqJQd4NPz9st7mBT0JkZ9nEK1gfyF2RmnrXZog@mail.gmail.com>
Subject: Re: [PATCHv5 20/20] MAINTAINERS: add maintainer entry for thermal bindings
From: Olof Johansson <olof@lixom.net>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Guenter Roeck <linux@roeck-us.net>, rui.zhang@intel.com,
        wni@nvidia.com, Grant Likely <grant.likely@linaro.org>,
        durgadoss.r@intel.com, linux-pm@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        lm-sensors@lm-sensors.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 11:46 AM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> After discussion and agreement of thermal device tree bindings,
> it is desirable to properly maintain thermal bindings for
> existing and upcoming devices.
>
> As original author of thermal device tree bindings, I am
> volunteering to maintain them.
>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3438384..94bfc46 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6178,6 +6178,7 @@ M:        Pawel Moll <pawel.moll@arm.com>
>  M:     Mark Rutland <mark.rutland@arm.com>
>  M:     Stephen Warren <swarren@wwwdotorg.org>
>  M:     Ian Campbell <ijc+devicetree@hellion.org.uk>
> +M:     Eduardo Valentin <eduardo.valentin@ti.com>
>  L:     devicetree@vger.kernel.org
>  S:     Maintained
>  F:     Documentation/devicetree/

The number of device-tree maintainers is getting to be somewhat silly.
You don't have to be a maintainer to be a reviewer, and the number is
getting large enough that it might get hard for one maintainer to know
what another is doing.

So, soft nack, but it's really up to the DT guys.


-Olof
