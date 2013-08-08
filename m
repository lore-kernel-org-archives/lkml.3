Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966020Ab3HHRhb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:37:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:33188 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966000Ab3HHRha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:37:30 -0400
Message-ID: <5203D757.8000208@wwwdotorg.org>
Date: Thu, 08 Aug 2013 11:37:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: khali@linux-fr.org, linux@roeck-us.net, MLongnecker@nvidia.com,
        linux-arm-kernel@lists.infradead.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 3/3] Documentation: dt: hwmon: add OF document for
 lm90
References: <1375944991-29182-1-git-send-email-wni@nvidia.com> <1375944991-29182-4-git-send-email-wni@nvidia.com>
In-Reply-To: <1375944991-29182-4-git-send-email-wni@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 12:56 AM, Wei Ni wrote:
> Add OF document for lm90 in Documentation/devicetree/.

> diff --git a/Documentation/devicetree/bindings/hwmon/lm90.txt b/Documentation/devicetree/bindings/hwmon/lm90.txt

> +Required node properties:
> +- compatible: manufacture and chip name,
> +              which are listed in the Documentation/hwmon/lm90

You need to specify the exact values here. DT binding documentations
should be OS-agnostic, and hence can't depend on Linux-specific
documentation or other details.

> +Optional properties:
> +- vdd-supply: vdd regulator for the supply voltage. If this is not set,

s/set/present/.

> +- interrupts: lm90 can support interrupt mode, you can set interrupt here.

You might want to mention that a single entry ("specifier") is expected
in the list.
