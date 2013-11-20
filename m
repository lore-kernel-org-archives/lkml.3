Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab3KTMzv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 07:55:51 -0500
Received: from mga02.intel.com ([134.134.136.20]:5948 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358Ab3KTMzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 07:55:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="411760533"
Message-ID: <1384952119.6723.0.camel@smile>
Subject: Re: [PATCH v1.2] gpiolib: append SFI helpers for GPIO API
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: Alex Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Wed, 20 Nov 2013 14:55:19 +0200
In-Reply-To: <528BA0C6.8010604@linux.intel.com>
References: <1370440690-21898-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CACRpkdaP+tkJn8jcR_RaCz_c6hk66F8qde2KRiCzNyyLWUkgjw@mail.gmail.com>
	 <528B2EF2.5010104@nvidia.com> <528BA0C6.8010604@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-19 at 09:32 -0800, David Cohen wrote:

[]

> >> Maybe that header could move to <linux/gpio/sfi.h> instead.
> >> Alexandre what do you think?
> >
> > Agreed - all the GPIO drivers into drivers/gpio, all the headers into
> > include/linux/gpio. Logical. :)
> 
> Sounds nice.
> Andy, would you like to update the patch or should I go ahead and
> resend it myself?

I already had done this, but I can't check since linux-next is broken
for me. Once I tried it I send it here.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

