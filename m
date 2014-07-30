Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755125AbaG3QOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 12:14:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:20816 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705AbaG3QO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 12:14:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,765,1400050800"; 
   d="scan'208";a="577763483"
Date: Wed, 30 Jul 2014 21:36:07 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        laurent.pinchart@ideasonboard.com, ludovic.desroches@atmel.com,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] Documentation: dmaengine: Add a documentation for the
 dma controller API
Message-ID: <20140730160607.GM8181@intel.com>
References: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406736193-26685-1-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 06:03:13PM +0200, Maxime Ripard wrote:
> The dmaengine is neither trivial nor properly documented at the moment, which
> means a lot of trial and error development, which is not that good for such a
> central piece of the system.
> 
> Attempt at making such a documentation.

Did you miss Documentation/dmaengine.txt, lots of this is already covered
there. But yes i would be really glad to know what isnt, so that we can fix
that.

> +  * device_slave_caps
> +    - Isn't that redundant with the cap_mask already?
> +    - Only a few drivers seem to implement it
For audio to know what your channel can do rather than hardcoding it

> +
> +  * dma cookies?
cookie is dma transaction representation which is monotonically incrementing
number.

-- 
~Vinod
