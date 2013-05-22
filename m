Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414Ab3EVICU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:02:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:60331 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab3EVICQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:02:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,718,1363158000"; 
   d="scan'208";a="341555697"
Date: Wed, 22 May 2013 11:06:23 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        David Cohen <david.a.cohen@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] gpio-langwell: amend error messages
Message-ID: <20130522080623.GX11878@intel.com>
References: <1369208859-16514-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1369208859-16514-5-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369208859-16514-5-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 10:47:39AM +0300, Andy Shevchenko wrote:
> There is no need to use hardcoded device name in the error messages, because
> dev_err() prefixes the message with the device name anyway.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
