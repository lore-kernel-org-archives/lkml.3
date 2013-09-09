Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab3IIK57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 06:57:59 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41695 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3IIK55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 06:57:57 -0400
MIME-Version: 1.0
In-Reply-To: <1378722552-10357-3-git-send-email-wni@nvidia.com>
References: <1378722552-10357-1-git-send-email-wni@nvidia.com> <1378722552-10357-3-git-send-email-wni@nvidia.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 9 Sep 2013 16:27:16 +0530
Message-ID: <CALkWK0nqgF6yn4QRe2tTD-Qd+5GLtH-ifCesayk-+uxkWMx-5w@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] Documentation: dt: hwmon: add OF document for LM90
To: Wei Ni <wni@nvidia.com>
Cc: khali@linux-fr.org, Guenter Roeck <linux@roeck-us.net>, broonie@kernel.org,
        swarren@wwwdotorg.org, lm-sensors@lm-sensors.org,
        linux-tegra@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wei Ni wrote:
> diff --git a/Documentation/devicetree/bindings/hwmon/lm90.txt b/Documentation/devicetree/bindings/hwmon/lm90.txt
> new file mode 100644
> index 0000000..5570875
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hwmon/lm90.txt

While at it, please update and rename ads1015.txt.

> @@ -0,0 +1,44 @@
> +* LM90 series thermometer.
> +
> +Required node properties:
> +- compatible: manufacture and chip name, one of
> +               "<manufacture>,adm1032"
> +               "<manufacture>,adt7461"
> +               "<manufacture>,adt7461a"
> +               "<manufacture>,g781"
> +               "<manufacture>,lm90"
> +               "<manufacture>,lm86"
> +               "<manufacture>,lm89"
> +               "<manufacture>,lm99"

More versions of this of different ages are required.

> +               "<manufacture>,max6646"
> +               "<manufacture>,max6647"
> +               "<manufacture>,max6649"
> +               "<manufacture>,max6657"
> +               "<manufacture>,max6658"
> +               "<manufacture>,max6659"
> +               "<manufacture>,max6680"
> +               "<manufacture>,max6681"
> +               "<manufacture>,max6695"
> +               "<manufacture>,max6696"

SSDNow devices are required.
