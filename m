Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761Ab3K0Cab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:30:31 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3917 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758068Ab3K0Ca0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:30:26 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 26 Nov 2013 18:24:07 -0800
Message-ID: <5295593C.309@nvidia.com>
Date: Wed, 27 Nov 2013 11:30:20 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/6] net: rfkill: gpio: convert to descriptor-based
 GPIO interface
References: <1385460350-17543-1-git-send-email-mika.westerberg@linux.intel.com> <1385460350-17543-3-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1385460350-17543-3-git-send-email-mika.westerberg@linux.intel.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 07:05 PM, Mika Westerberg wrote:
> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>
> Convert to the safer gpiod_* family of API functions.

Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
