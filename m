Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725Ab3EaODZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 10:03:25 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:40611 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837Ab3EaODR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 10:03:17 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZnaN=TOB9nZJUS5EPXcCDoMiBvoL47AufDOOcDoH-khg@mail.gmail.com>
References: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1369218014-28990-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<CACRpkdZnaN=TOB9nZJUS5EPXcCDoMiBvoL47AufDOOcDoH-khg@mail.gmail.com>
Date: Fri, 31 May 2013 17:03:16 +0300
Message-ID: <CAHp75Vf3C-2RFpFu+mByiB=eLPzDNXtJqXJuAcivqHuBJXR5VA@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] gpio-langwell: initialize lock before usage
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Cohen <david.a.cohen@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 3:01 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, May 22, 2013 at 12:20 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>
>> Otherwise we will end up with traceback from LOCKDEP:
>
> Andy do you consider this a regression that needs to go into fixes?

I think so. The commit
2519f9abced15b4327f03d7b8666827517582c29
was the recent one which probably brought such behaviour.

> I.e. is this used in in-tree code and causing problems with v3.10...
>
> I'm asking because it creates a mess as the rest of the series depend
> on it.
>
> It is currently applied for v3.11.

Perhaps it should go to v3.10 as well.

--
With Best Regards,
Andy Shevchenko
