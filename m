Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202Ab3FTH6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:58:12 -0400
Received: from mga14.intel.com ([143.182.124.37]:21068 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012Ab3FTH6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:58:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,903,1363158000"; 
   d="scan'208";a="257616885"
Date: Thu, 20 Jun 2013 11:02:12 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Cohen <david.a.cohen@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio-langwell: remove Withney point support
Message-ID: <20130620080212.GO11878@intel.com>
References: <1371537818-19579-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <CACRpkdYMiNnCy26px26ofY8MCbw_VSgOpOncS=5YK3vd9BC9yA@mail.gmail.com>
 <CAHp75VexskPUkqKhE2fowc=cscyGSvirz9d9igy37BveFYGVKA@mail.gmail.com>
 <CACRpkdZCjNGMxbnR7e_8x1GPxCLe5KzsY8ep8Unnqq4gFg07sg@mail.gmail.com>
 <CAHp75VdqOTUtp=LEN8hbxJq1E2-BxhxVW0BtHUYhW=-4soYqsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VdqOTUtp=LEN8hbxJq1E2-BxhxVW0BtHUYhW=-4soYqsQ@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 10:09:37AM +0300, Andy Shevchenko wrote:
> On Thu, Jun 20, 2013 at 9:46 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Wed, Jun 19, 2013 at 11:02 PM, Andy Shevchenko
> > <andy.shevchenko@gmail.com> wrote:
> >> On Wed, Jun 19, 2013 at 10:23 PM, Linus Walleij
> >> <linus.walleij@linaro.org> wrote:
> >>
> >>> Please give some context though, Wikipedia says:
> >>>
> >>> Whitney Point is the codename of a PCH in the Oak Trail platform
> >>> chipset for Atom Lincroft microprocessors.
> >>> This has the following variations:
> >>> 82SM35 (PCH SM35)
> >>
> >>> Does this mean that platform is not coming back to support Linux
> >>> ever again
> >>
> >> I think it's very unluckily.
> >> May be David could shed a light...
> >
> > Is that some kind of NACK?
> 
> No, the opposite.
> I meant it's very unluckily that we will have any Oak Trail user in future.

You mean *unlikely*, right?

AFAICT there are no real Oak Trail products outside Intel. It was
superseded by Medfield.
