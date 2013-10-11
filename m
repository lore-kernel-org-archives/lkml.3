Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932390Ab3JKLER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 07:04:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:58660 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932119Ab3JKLEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 07:04:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1079,1371106800"; 
   d="scan'208";a="417690706"
Date: Fri, 11 Oct 2013 14:09:40 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio/lynxpoint: check if the interrupt is enabled in IRQ
 handler
Message-ID: <20131011110940.GO3521@intel.com>
References: <1380638143-20040-1-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkda=C3+pkVsVbZAkasxyWGedNsb7oAKTt4ApnJ4Q+k9BCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkda=C3+pkVsVbZAkasxyWGedNsb7oAKTt4ApnJ4Q+k9BCw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 12:57:37PM +0200, Linus Walleij wrote:
> On Tue, Oct 1, 2013 at 4:35 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > Checking LP_INT_STAT is not enough in the interrupt handler because its
> > contents get updated regardless of whether the pin has interrupt enabled or
> > not. This causes the driver to loop forever for GPIOs that are pulled up.
> >
> > Fix this by checking the interrupt enable bit for the pin as well.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Patch applied for fixes with Mathias ACK.

Thanks!

> Should this be tagged for -stable as well?

Yes, please. I think starting from 3.9 when this driver was merged.
