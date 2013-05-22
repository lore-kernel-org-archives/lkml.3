Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406Ab3EVLDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 07:03:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:28783 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230Ab3EVLDs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 07:03:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,719,1363158000"; 
   d="scan'208";a="341324734"
Date: Wed, 22 May 2013 14:07:43 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        David Cohen <david.a.cohen@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] gpio-langwell: drop away explicit casting
Message-ID: <20130522110743.GA11878@intel.com>
References: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1369218014-28990-6-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369218014-28990-6-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 01:20:14PM +0300, Andy Shevchenko wrote:
> Since the type of the reg_base member is void __iomem * we don't need to have
> explicit casting in gpio_reg() and gpio_reg_2bit().
> 
> Update year in the copyright notice as well.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
