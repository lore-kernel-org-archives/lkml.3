Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab3KZUdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 15:33:17 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37239 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab3KZUdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 15:33:15 -0500
Message-ID: <52950585.2080802@wwwdotorg.org>
Date: Tue, 26 Nov 2013 13:33:09 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/6] ARM: tegra: add gpiod_lookup table for paz00
References: <1385460350-17543-1-git-send-email-mika.westerberg@linux.intel.com> <1385460350-17543-2-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1385460350-17543-2-git-send-email-mika.westerberg@linux.intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 03:05 AM, Mika Westerberg wrote:
> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> 
> This makes it possible to request the gpio descriptors in
> rfkill_gpio driver regardless of the platform.

V2 of the series did the following:

 static struct rfkill_gpio_platform_data wifi_rfkill_platform_data = {
 	.name		= "wifi_rfkill",
-	.reset_gpio	= 25, /* PD1 */
-	.shutdown_gpio	= 85, /* PK5 */
 	.type	= RFKILL_TYPE_WLAN,
 };

I assume that will happen sometime, along with removing those two fields
from the struct definition.
