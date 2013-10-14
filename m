Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab3JNKiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:38:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:32486 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500Ab3JNKiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:38:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,491,1378882800"; 
   d="scan'208";a="418797448"
Date: Mon, 14 Oct 2013 13:43:48 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] gpiolib / ACPI: move
 acpi_gpiochip_free_interrupts next to the request function
Message-ID: <20131014104348.GF3521@intel.com>
References: <1381392071-21407-1-git-send-email-mika.westerberg@linux.intel.com>
 <1381392071-21407-2-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdZgP9VnVSpBN2Wg4ihL4ryZXeP=ASwr6BCP=u79eg6s6g@mail.gmail.com>
 <CAAVeFu+K6HvQTMOQqMbZPUD_C3nQ1MvYju1BGUOWPYJjQEpTjg@mail.gmail.com>
 <CACRpkdaVyLwOC-b2mKDRAfCQPzFZKEAm8OZxvHtbpc1koeUz-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaVyLwOC-b2mKDRAfCQPzFZKEAm8OZxvHtbpc1koeUz-w@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 08:58:05AM +0200, Linus Walleij wrote:
> On Fri, Oct 11, 2013 at 6:42 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
> > On Fri, Oct 11, 2013 at 4:00 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> >> On Thu, Oct 10, 2013 at 10:01 AM, Mika Westerberg
> >> <mika.westerberg@linux.intel.com> wrote:
> >>
> >>> It makes more sense to have these functions close to each other. No
> >>> functional changes.
> >>>
> >>> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >>> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>
> >> So I've applied this first patch, and I'm just waiting for Alexandre's
> >> ACK on the remaining patches concerning gpiod so we get this
> >> 100% right.
> >
> > I think I'm ok with Mika's patches, however I need to send you a new
> > version of gpiod. I wanted to finish documentation first, but maybe
> > that can come slightly after so you can at least go ahead with both
> > series?
> 
> The important thing right now is to get it in a testable form I think?
> So that I can throw it at the autobuilder and it gets included into
> linux-next as that comes back online.
> 
> So give me whatever you have ... BTW is this series dependent on
> yours to go in first? Sorry for not seeing the details here...

Correct, this series depends on Alexandre's patches.
