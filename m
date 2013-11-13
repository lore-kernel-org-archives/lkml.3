Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168Ab3KMMRN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 07:17:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:61273 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758927Ab3KMMRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 07:17:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="434534686"
Message-ID: <1384345006.14845.56.camel@smile>
Subject: Re: [PATCH] gpiolib: append SFI helpers for GPIO API
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: David Cohen <david.a.cohen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>,
        Len Brown <lenb@kernel.org>
Date: Wed, 13 Nov 2013 14:16:46 +0200
In-Reply-To: <CACRpkdZG=Sa92qGqK4Jt-L1AVRmremK5tgn8O5-5JccUsZDHTA@mail.gmail.com>
References: <1381979015-28980-1-git-send-email-david.a.cohen@linux.intel.com>
	 <1382013695.29062.141.camel@smile>
	 <CACRpkdZG=Sa92qGqK4Jt-L1AVRmremK5tgn8O5-5JccUsZDHTA@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-12 at 19:55 +0100, Linus Walleij wrote:
> On Thu, Oct 17, 2013 at 2:41 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> > On Wed, 2013-10-16 at 20:03 -0700, David Cohen wrote:
> >> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> >>
> >> To support some (legacy) firmwares and platforms let's make life easier for
> >> their customers.
> >
> >> +int sfi_get_gpio_by_name(const char *name)
> >> +{
> >> +     struct sfi_gpio_table_entry *pentry = sfi_gpio_table;
> >> +     int i;
> >> +
> >> +     if (!pentry)
> >> +             return -1;
> >
> > ^^^^ It seems an old version.
> >
> > New version was published while ago and even has an ACK from Linus:
> >
> > http://www.spinics.net/lists/kernel/msg1545960.html
> 
> So what is happening to this thing?

Actually David now coordinates work done for Medfield & Co.
Perhaps he is not absent and could answer fast to this.

> Is there some newer patch I should be merging?

I'm pretty sure there is no newest version of patch.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

