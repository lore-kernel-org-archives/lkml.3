Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab3GVJyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 05:54:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:42430 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab3GVJyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 05:54:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,718,1367996400"; 
   d="scan'208";a="374456925"
Date: Mon, 22 Jul 2013 14:45:38 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: Viresh Kumar <viresh.linux@gmail.com>, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Subject: Re: [PATCH 1/6] acpi-dma: fix sparse warning
Message-ID: <20130722091538.GA18642@intel.com>
References: <1373889881-21075-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373889881-21075-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 03:04:36PM +0300, Andy Shevchenko wrote:
> This patch fixes sparse warning:
> 	drivers/dma/acpi-dma.c:76:21: sparse: cast to restricted __le32
> 
> Since everything in all ACPI tables is little-endian, by definition, the used
> types in practice are uXX. Thus, we have to enforce __leXX if we want to
> convert them to CPU order.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Applied all, thanks

--
~Vinod
