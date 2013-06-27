Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183Ab3F0WTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 18:19:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:18745 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab3F0WTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 18:19:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,955,1363158000"; 
   d="scan'208";a="360735007"
Date: Thu, 27 Jun 2013 15:14:18 -0700
From: Kevin Strasser <kevin.strasser@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Michael Brunner <mibru@gmx.de>, Chris Healy <chealy@imsco-us.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH v2 3/4] gpio: Kontron PLD gpio driver
Message-ID: <20130627221418.GC16090@wrk>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
 <1371589469-32700-1-git-send-email-kevin.strasser@linux.intel.com>
 <1371589469-32700-4-git-send-email-kevin.strasser@linux.intel.com>
 <CACRpkdYEuC_czRHZycgN81u8QEU-n5XjV5-DJgpF4AJMKJpxQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYEuC_czRHZycgN81u8QEU-n5XjV5-DJgpF4AJMKJpxQA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Jun 19, 2013 at 10:36:34AM +0200, Linus Walleij wrote:
> On Tue, Jun 18, 2013 at 11:04 PM, Kevin Strasser
> <kevin.strasser@linux.intel.com> wrote:
> 
> > Add gpio support for the on-board PLD found on some Kontron embedded modules.
> >
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > Signed-off-by: Kevin Strasser <kevin.strasser@linux.intel.com>
> > Signed-off-by: Michael Brunner <michael.brunner@kontron.com>
> > Acked-by: Darren Hart <dvhart@linux.intel.com>
> 
> This is looking good.
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Thanks for the review. Are you planning on taking this in gpio-next,
or would you prefer that it goes through mfd?

Thanks,
Kevin

> 
> Yours,
> Linus Walleij
