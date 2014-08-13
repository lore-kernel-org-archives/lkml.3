Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaHMMgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:36:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:4330 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaHMMgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:36:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,856,1400050800"; 
   d="scan'208";a="576080322"
Date: Wed, 13 Aug 2014 15:36:22 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Linus <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: baytrail: resolve unbalanced IRQ wake disable
 warning
Message-ID: <20140813123622.GI1657@lahna.fi.intel.com>
References: <1407765115-31662-1-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407765115-31662-1-git-send-email-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 04:51:55PM +0300, Mathias Nyman wrote:
> Add the IRQCHIP_SKIP_SET_WAKE flag to baytrail gpio irq_chip
> to resolve unbalaced IRQ wake disable warnings.
> 
> Suggested-by: Borun Fu <borun.fu@intel.com>
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
