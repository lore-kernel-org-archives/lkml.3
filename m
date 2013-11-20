Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab3KTOhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:37:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:4320 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab3KTOhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:37:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,737,1378882800"; 
   d="scan'208";a="430896954"
Message-ID: <1384958201.6723.1.camel@smile>
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
Date: Wed, 20 Nov 2013 16:36:41 +0200
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
> On 11/19/2013 01:27 AM, Alex Courbot wrote:
> > On 11/19/2013 06:24 PM, Linus Walleij wrote:
> >> On Wed, Jun 5, 2013 at 3:58 PM, Andy Shevchenko
> >> <andriy.shevchenko@linux.intel.com> wrote:
> >>
> >>> To support some (legacy) firmwares and platforms let's make life
> >>> easier for
> >>> their customers.
> >>>
> >>> This patch extracts SFI GPIO API from arch/x86/platform/mrst/mrst.c.
> >>>
> >>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >>
> >> So since this patch was ACKed the world has changed a bit and now
> >> I want new changes (or maybe I was tired and not paying enough
> >> attention at the time).
> 
> Agreed. Even my e-mail was outdated :)
> Updating from david.a.cohen@intel.com to david.a.cohen@linux.intel.com
> to avoid M$ servers.

Just sent a version, though, sorry, I forgot to update your email there.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

