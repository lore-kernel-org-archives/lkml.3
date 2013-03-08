Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945Ab3CHMp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 07:45:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:51193 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933779Ab3CHMpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 07:45:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,807,1355126400"; 
   d="scan'208";a="296747568"
Date: Fri, 8 Mar 2013 14:49:34 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: Linus <linus.walleij@linaro.org>, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio-lynxpoint: Add X86 dependency and io-port handling
 header.
Message-ID: <20130308124934.GD31790@intel.com>
References: <1362746292-4385-1-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362746292-4385-1-git-send-email-mathias.nyman@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 02:38:12PM +0200, Mathias Nyman wrote:
> Lynxpoint gpio driver uses X86 specific io-ports to control gpios
> 
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
