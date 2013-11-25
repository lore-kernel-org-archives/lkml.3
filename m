Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab3KYIwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:52:31 -0500
Received: from mga03.intel.com ([143.182.124.21]:31220 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989Ab3KYIw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:52:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,766,1378882800"; 
   d="scan'208";a="433200265"
Date: Mon, 25 Nov 2013 10:58:57 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpiolib: fix lookup of platform-mapped GPIOs
Message-ID: <20131125085857.GP2281@intel.com>
References: <1385186152-29188-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385186152-29188-1-git-send-email-acourbot@nvidia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 02:55:52PM +0900, Alexandre Courbot wrote:
> A typo resulted in GPIO lookup failing unconditionally.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Reported-by: Stephen Warren <swarren@wwwdotorg.org>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
