Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbaJ2I5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:57:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:48361 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbaJ2I45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:56:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,808,1406617200"; 
   d="scan'208";a="622640230"
Date: Wed, 29 Oct 2014 10:56:52 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com, Arnd Bergmann <arnd@arndb.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v2] Documentation: gpio: guidelines for bindings
Message-ID: <20141029085652.GK1304@lahna.fi.intel.com>
References: <1414570394-11706-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414570394-11706-1-git-send-email-acourbot@nvidia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 05:13:14PM +0900, Alexandre Courbot wrote:
> Now that ACPI supports named GPIO properties, either through ACPI 5.1 or
> the per-driver ACPI GPIO mappings, we can be more narrow about the way
> GPIOs should be specified in Device Tree bindings.
> 
> This patch updates the GPIO DT bindings documentation to highlight the
> following rules for new GPIO bindings:
> 
> - All new bindings must have a meaningful name (e.g. the "gpios"
>   property must not be used)
> - The only suffix allowed is "-gpios", no matter the number of
>   descriptors in the property
> - GPIOs can only be grouped under the same property when they serve the
>   same purpose, a case that should remain exceptional (e.g. bit-banged
>   data lines).
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Rafael J. Wysocki <rjw@rjwysocki.net>
> CC: Mika Westerberg <mika.westerberg@linux.intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
