Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3K0Lzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:55:48 -0500
Received: from mga03.intel.com ([143.182.124.21]:42937 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab3K0Lzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:55:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,781,1378882800"; 
   d="scan'208";a="435028213"
Message-ID: <1385553315.1871.8.camel@smile>
Subject: Re: [PATCH v2 3/3] intel_mid: switch to use SFI GPIO API
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: David Cohen <david.a.cohen@intel.com>,
        "linux-gpio @ vger . kernel . org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Date: Wed, 27 Nov 2013 13:55:15 +0200
In-Reply-To: <CACRpkdawieDmHhOj4p4KVgE=FH5LaxWG94U0btbPgX_5ue-Lyg@mail.gmail.com>
References: <1384957896-3477-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1384957896-3477-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CACRpkdawieDmHhOj4p4KVgE=FH5LaxWG94U0btbPgX_5ue-Lyg@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-26 at 10:38 +0100, Linus Walleij wrote:
> On Wed, Nov 20, 2013 at 3:31 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> 
> > Instead of custom implementation of the SFI GPIO API let's use one provided by
> > gpiolib.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> So is it possible to move this to just do gpiod_get() from the drivers
> and abstract away SFI altogether as indicated by Mika?
> 
> I'd love that, if possible.

I will look at it later.
Anyway it's apparently for 3.14.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

