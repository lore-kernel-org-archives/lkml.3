Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab3FROcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:32:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:31626 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691Ab3FROce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:32:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,889,1363158000"; 
   d="scan'208";a="318850890"
Date: Tue, 18 Jun 2013 17:36:22 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] acpi-dma: fix sparse warning
Message-ID: <20130618143622.GC11878@intel.com>
References: <1371565167-27700-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371565167-27700-1-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 05:19:27PM +0300, Andy Shevchenko wrote:
> This patch fixes sparse warning:
> 	drivers/dma/acpi-dma.c:76:21: sparse: cast to restricted __le32
> 
> Since everything in all ACPI tables is little-endian, by definition, the used
> types in practice are uXX. Thus, we have to enforce __leXX if we want to
> convert them to CPU order.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Even though it is ugly,

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
