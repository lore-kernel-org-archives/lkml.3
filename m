Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab3KZJi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 04:38:57 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:50380 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab3KZJiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 04:38:54 -0500
MIME-Version: 1.0
In-Reply-To: <1384957896-3477-4-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1384957896-3477-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1384957896-3477-4-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 26 Nov 2013 10:38:53 +0100
Message-ID: <CACRpkdawieDmHhOj4p4KVgE=FH5LaxWG94U0btbPgX_5ue-Lyg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] intel_mid: switch to use SFI GPIO API
From: Linus Walleij <linus.walleij@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Cohen <david.a.cohen@intel.com>,
        "linux-gpio @ vger . kernel . org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sathyanarayanan Kuppuswamy <sathyanarayanan.kuppuswamy@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel @ vger . kernel . org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 3:31 PM, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

> Instead of custom implementation of the SFI GPIO API let's use one provided by
> gpiolib.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

So is it possible to move this to just do gpiod_get() from the drivers
and abstract away SFI altogether as indicated by Mika?

I'd love that, if possible.

Yours,
Linus Walleij
