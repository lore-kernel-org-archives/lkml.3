Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758300Ab3K0C3K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:29:10 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8455 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951Ab3K0C3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:29:04 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 26 Nov 2013 18:26:36 -0800
Message-ID: <529558EA.9090206@nvidia.com>
Date: Wed, 27 Nov 2013 11:28:58 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/6] ARM: tegra: add gpiod_lookup table for paz00
References: <1385460350-17543-1-git-send-email-mika.westerberg@linux.intel.com> <1385460350-17543-2-git-send-email-mika.westerberg@linux.intel.com> <52950585.2080802@wwwdotorg.org>
In-Reply-To: <52950585.2080802@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/2013 05:33 AM, Stephen Warren wrote:
> On 11/26/2013 03:05 AM, Mika Westerberg wrote:
>> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>>
>> This makes it possible to request the gpio descriptors in
>> rfkill_gpio driver regardless of the platform.
>
> V2 of the series did the following:
>
>   static struct rfkill_gpio_platform_data wifi_rfkill_platform_data = {
>   	.name		= "wifi_rfkill",
> -	.reset_gpio	= 25, /* PD1 */
> -	.shutdown_gpio	= 85, /* PK5 */
>   	.type	= RFKILL_TYPE_WLAN,
>   };
>
> I assume that will happen sometime, along with removing those two fields
> from the struct definition.

This needs to happen after patch 2 of this series, but would be nice to 
have indeed. Would suggest to do it in a separate patch if this series 
needs no more revision.

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
