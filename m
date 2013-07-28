Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab3G1OYl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 10:24:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:21945 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab3G1OYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 10:24:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,763,1367996400"; 
   d="scan'208";a="353153186"
Date: Sun, 28 Jul 2013 19:15:46 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Dan Williams <djbw@fb.com>, Jassi Brar <jaswinder.singh@linaro.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] dma: pl330: Fix cyclic transfers
Message-ID: <20130728134546.GE1986@intel.com>
References: <1374567890-27593-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374567890-27593-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 10:24:50AM +0200, Lars-Peter Clausen wrote:
> Allocate a descriptor for each period of a cyclic transfer, not just the first.
> Also since the callback needs to be called for each finished period make sure to
> initialize the callback and callback_param fields of each descriptor in a cyclic
> transfer.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Applied thanks

Btw the switch moved should have return error for default case when direction is
not slave, but thats not in context of this as you moved that code

~Vinod
