Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbaD1Jmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:42:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:43433 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195AbaD1Jmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:42:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,942,1389772800"; 
   d="scan'208";a="502187428"
Message-ID: <1398678159.11914.285.camel@smile.fi.intel.com>
Subject: Re: [PATCH v3 1/3] Input: gpio_keys - use dev instead of pdev in
 gpio_keys_setup_key()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 28 Apr 2014 12:42:39 +0300
In-Reply-To: <20140425212112.GA16783@core.coreip.homeip.net>
References: <1398442937-15309-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1398442937-15309-2-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20140425212112.GA16783@core.coreip.homeip.net>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 14:21 -0700, Dmitry Torokhov wrote:
> On Fri, Apr 25, 2014 at 07:22:15PM +0300, Andy Shevchenko wrote:
> > The platform device is not used in gpio_keys_setup_key(). This patch
> > substitutes it by struct device.
> 
> And the benefit of this is...?

Probably no benefit for now. Let's drop it for good.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

