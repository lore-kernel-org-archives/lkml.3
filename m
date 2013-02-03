Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3BCWco (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 17:32:44 -0500
Received: from mga01.intel.com ([192.55.52.88]:55027 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab3BCWcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 17:32:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,595,1355126400"; 
   d="scan'208";a="282279402"
Date: Sun, 3 Feb 2013 23:32:29 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mfd: vexpress: Add pseudo-GPIO based LEDs
Message-ID: <20130203223229.GA8476@sortiz-mobl>
References: <1359541996-18127-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359541996-18127-1-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pawel,

On Wed, Jan 30, 2013 at 10:33:16AM +0000, Pawel Moll wrote:
> The LEDs on the Versatile Express motherboard are controlled
> through simple memory-mapped register. This patch extends
> the pseudo-GPIO controller definition for these lines and
> creates generic "leds-gpio" device using them
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
> 
> Hello Samuel,
> 
> Would you be so kind to take this patch in for 3.9? Or would
> you prefer to get it in through arm-soc tree?
> 
> Thanks!
> 
> Pawel
> 
>  drivers/mfd/vexpress-sysreg.c |   73 +++++++++++++++++++++++++++++++----------
>  include/linux/vexpress.h      |    8 +++++
>  2 files changed, 63 insertions(+), 18 deletions(-)
Applied to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
