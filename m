Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965829Ab3FUAp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 20:45:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:18308 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965395Ab3FUAp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 20:45:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,908,1363158000"; 
   d="scan'208";a="333064605"
Message-ID: <51C3A2F5.7030902@intel.com>
Date: Thu, 20 Jun 2013 17:48:53 -0700
From: David Cohen <david.a.cohen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130315 Icedove/17.0.4
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio-langwell: remove Withney point support
References: <1371537818-19579-1-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1371537818-19579-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On 06/17/2013 11:43 PM, Andy Shevchenko wrote:
> It seems there is no user of the wp_gpio driver in the kernel. Let's remove it.

I never liked this wp code there too.

>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Acked-by: David Cohen <david.a.cohen@intel.com>

