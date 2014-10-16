Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbaJPKGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:06:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:52161 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078AbaJPKGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:06:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,731,1406617200"; 
   d="scan'208";a="619770806"
Date: Thu, 16 Oct 2014 13:06:01 +0300
From: Mika Westerberg <mika.westerberg@intel.com>
To: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Denis Turischev <denis.turischev@compulab.co.il>
Subject: Re: [PATCHv3 1/3] gpio: sch: Consolidate similar algorithms
Message-ID: <20141016100601.GA2255@lahna.fi.intel.com>
References: <1413431475-12799-1-git-send-email-rebecca.swee.fun.chang@intel.com>
 <1413431475-12799-2-git-send-email-rebecca.swee.fun.chang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413431475-12799-2-git-send-email-rebecca.swee.fun.chang@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 11:51:13AM +0800, Chang Rebecca Swee Fun wrote:
> Consolidating similar algorithms into common functions to make
> GPIO SCH simpler and manageable.
> 
> Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
