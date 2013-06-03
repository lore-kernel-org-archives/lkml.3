Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab3FCM0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 08:26:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:54921 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676Ab3FCM0G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 08:26:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,792,1363158000"; 
   d="scan'208";a="323483300"
Message-ID: <1370262344.29283.255.camel@smile>
Subject: Re: [RFC PATCH v0 0/2] dw_dmac: move to own folder and split
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>
Date: Mon, 03 Jun 2013 15:25:44 +0300
In-Reply-To: <CAKohpo=5+6X79tJaHd0BvKzECNqpiUcp9eybSSMDcJCkF8HVng@mail.gmail.com>
References: <1370015432-17259-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CAKohpo=5+6X79tJaHd0BvKzECNqpiUcp9eybSSMDcJCkF8HVng@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 10:35 +0530, Viresh Kumar wrote: 
> On 31 May 2013 21:20, Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
> > This is first attempt to do split as suggested by Arnd et al.
> > First patch moves driver to its own folder.
> > Second one does the actual split.
> >
> > During this files are renamed: mostly means that dw_dmac prefix is eliminated.
> > I hope to get it ready to be included in v3.11.

> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Thanks for review.

I still have doubts about few things.

I did renaming twice, first time it's actually moving to folder and
keeping the same file names, and second time when I split driver. Might
be better to do this in first patch? My logic here is to distinguish
just moving, that's why I kept names.

In patch 2/2 I collect platform related code. I see a lot of #ifdefs
related to OF and ACPI. I would like to split it further and create
files like of.c and acpi.c. What do you think?

Last thing, I would like to prepare PCI driver (which is not ready yet
in new shape) and see how it will go with this split.

And I forgot to mention that patch series relies on the patch I sent
before (clean up for devm_ioremap_resources) and Vinod didn't apply yet.

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
