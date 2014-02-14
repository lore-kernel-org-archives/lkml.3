Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaBNNbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 08:31:07 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33148 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751288AbaBNNbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 08:31:04 -0500
Date: Fri, 14 Feb 2014 13:31:01 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marek Belisko <marek@goldelico.com>
Cc: "robh+dt@kernel.org" <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rob@landley.net" <rob@landley.net>,
        "jdelvare@suse.de" <jdelvare@suse.de>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "hns@goldelico.com" <hns@goldelico.com>
Subject: Re: [PATCH] hwmon: twl4030-madc-hwmon: Add device tree support.
Message-ID: <20140214133101.GA17796@e106331-lin.cambridge.arm.com>
References: <1392384058-14240-1-git-send-email-marek@goldelico.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392384058-14240-1-git-send-email-marek@goldelico.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 01:20:58PM +0000, Marek Belisko wrote:
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> ---
>  Documentation/devicetree/bindings/hwmon/twl4030-madc-hwmon.txt |  9 +++++++++
>  drivers/hwmon/twl4030-madc-hwmon.c                             | 10 ++++++++++
>  2 files changed, 19 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/hwmon/twl4030-madc-hwmon.txt
> 
> diff --git a/Documentation/devicetree/bindings/hwmon/twl4030-madc-hwmon.txt b/Documentation/devicetree/bindings/hwmon/twl4030-madc-hwmon.txt
> new file mode 100644
> index 0000000..e8016d1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hwmon/twl4030-madc-hwmon.txt
> @@ -0,0 +1,9 @@
> +TWL4030 MADC hwmon.
> +
> +Required properties:
> +- compatible: "ti,twl4030-madc-hwmon"
> +
> +Example:
> +madc-hwmon {
> +	compatible = "ti,twl4030-madc-hwmon";
> +};

Huh?

What is this a binding for? From a look at the driver in mainline this
just calls into functions from the twl4030 madc driver (which doesn't
seem to have a binding).

This doesn't look like a description of hardware, but rather a hack to
get a Linux driver to probe. As far as I can see, no useful information
is given by this binding.

Thanks,
Mark.
