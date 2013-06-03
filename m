Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab3FCNXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:23:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:56051 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757501Ab3FCNXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:23:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,792,1363158000"; 
   d="scan'208";a="250000563"
Message-ID: <1370265792.29283.260.camel@smile>
Subject: Re: [RFC PATCH v0 0/2] dw_dmac: move to own folder and split
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Date: Mon, 03 Jun 2013 16:23:12 +0300
In-Reply-To: <CAKohpokWj4fNxc3AQPvKoogJRjGaMkeU6r7OvPCkE2Rrj+OcGw@mail.gmail.com>
References: <1370015432-17259-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAKohpo=5+6X79tJaHd0BvKzECNqpiUcp9eybSSMDcJCkF8HVng@mail.gmail.com>
	 <1370262344.29283.255.camel@smile>
	 <CAKohpokWj4fNxc3AQPvKoogJRjGaMkeU6r7OvPCkE2Rrj+OcGw@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 18:42 +0530, Viresh Kumar wrote: 
> On 3 June 2013 17:55, Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:


> > In patch 2/2 I collect platform related code. I see a lot of #ifdefs
> > related to OF and ACPI. I would like to split it further and create
> > files like of.c and acpi.c. What do you think?
> 
> Naahh.. OF by itself doesn't mean anything here on this driver. It
> belongs to all the users that are using DT to enumerate it (Mostly
> ARM). And they are going to use platform_driver interface. So,
> code is well located currently too..

I got it.

> ACPI, I am not sure.. you need these routines in your pci stuff too?

No, ACPI is alike OF, it relies on platform driver.

> Keep it this way:
> - Keep all the common stuff across pci and platform in core.c
> - everything else in pci and platform files.

It seems it's kept in that way already.

Thanks for your comments!

I will resend patch series v1 w/o RFC and with PCI driver later (when it
will be ready). I will attach the missed patch to the series in case
Vinod doesn't apply it in time.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
