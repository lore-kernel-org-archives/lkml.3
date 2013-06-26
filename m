Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab3FZIqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:46:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:62025 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678Ab3FZIqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:46:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,941,1363158000"; 
   d="scan'208";a="359777096"
Message-ID: <1372236386.24799.58.camel@smile>
Subject: Re: [PATCH 6/8] minnowboard-keys: Bind MinnowBoard buttons to arrow
 keys
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, peter.p.waskiewicz.jr@intel.com,
        danders@circuitco.com, vishal.l.verma@intel.com,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        platform-driver-x86@vger.kernel.org
Date: Wed, 26 Jun 2013 11:46:26 +0300
In-Reply-To: <1ded9714150de50fac7fb6ee82166fbcb5621f7d.1372211451.git.dvhart@linux.intel.com>
References: <cover.1372211451.git.dvhart@linux.intel.com>
	 <1ded9714150de50fac7fb6ee82166fbcb5621f7d.1372211451.git.dvhart@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-25 at 18:53 -0700, Darren Hart wrote: 
> Configure the four buttons tied to the E6XX GPIO lines on the
> MinnowBoard as keys using the gpio-keys-polled platform driver. From
> left to right, bind them to LEFT, DOWN, UP, RIGHT, similar to the VI
> directional keys.
> 
> This is separate from the minnowboard driver to provide users with the
> flexibility to write kernel drivers for their own devices using these GPIO
> lines.

I'm repeating my comment I did early to you.

I think this driver is a wrong approach, since you just use
gpio_keys_polling with custom platform data. So, it should go to the
platform code / board file under arch/x86/platform/minnow/...


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
