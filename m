Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678Ab3EVLCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 07:02:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:63628 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639Ab3EVLCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 07:02:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,719,1363158000"; 
   d="scan'208";a="317683786"
Date: Wed, 22 May 2013 14:06:24 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        David Cohen <david.a.cohen@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/5] gpio-langwell: use managed functions pcim_* and
 devm_*
Message-ID: <20130522110624.GZ11878@intel.com>
References: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1369218014-28990-4-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369218014-28990-4-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 01:20:12PM +0300, Andy Shevchenko wrote:
> This makes the error handling much more simpler than open-coding everything and
> in addition makes the probe function smaller an tidier.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
