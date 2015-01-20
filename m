Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbbATPqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 10:46:53 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:50838 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbbATPqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 10:46:50 -0500
Date: Tue, 20 Jan 2015 15:46:44 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH v1 0/4] mfd: reorganize Intel drivers
Message-ID: <20150120154644.GF13701@x1>
References: <1418313236-10764-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <20150120134857.GK13701@x1>
 <1421763412.31903.70.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421763412.31903.70.camel@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jan 2015, Andy Shevchenko wrote:

> On Tue, 2015-01-20 at 13:48 +0000, Lee Jones wrote:
> > On Thu, 11 Dec 2014, Andy Shevchenko wrote:
> > 
> > > This patchset creates a new folder under drivers/mfd and moves there Intel
> > > related drivers.
> > > 
> > > There is no functional change. The names of the kernel configuration variables
> > > are kept the same.
> > 
> > Can you explain to me why you think the Intel drivers need their own
> > sub-directory please?
> 
> For me it seems logical. We have many drivers related to Intel specific
> SoCs (in comparison the other mfd drivers that usually named in
> according to some standard chip codename) and they meanwhile have long
> awkward prefixes. Moreover they could share common dependencies like
> X86.

I'm not comfortable with it and am yet to see the need.  What I would
suggest is to prefix 'intel-' or similar to the related files.  From
there we can see how overbearing the files are becoming and make a
decision based on that.

If there are too many Intel related files, my first question(s) will
be a) why are there so many files b) are so many files required and c)
should they really live in MFD.

But as yet, this patch-set is the only indication that something needs
to be done at all.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
