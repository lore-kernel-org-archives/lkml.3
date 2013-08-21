Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639Ab3HUMF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 08:05:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:4803 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480Ab3HUMF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 08:05:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,927,1367996400"; 
   d="scan'208";a="349534295"
Date: Wed, 21 Aug 2013 15:11:26 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] acpi-dma: remove ugly conversion
Message-ID: <20130821121126.GB6483@intel.com>
References: <1377084426-11179-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1377084426-11179-2-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377084426-11179-2-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 02:27:06PM +0300, Andy Shevchenko wrote:
> In case of big endian CPU we have to convert either all fields in the structure
> or leave this job to ACPICA. The second choice seems the best.
> 
> So, let's remove the ugly conversion that is not fully comprehensive anyway.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
