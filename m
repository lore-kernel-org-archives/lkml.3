Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308Ab3FRUBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 16:01:20 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:37199 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861Ab3FRUBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 16:01:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAA9_cmewUn1Gz_BJvmhuC46u_4b2xZ9SL-uEtefcaOg0ECBJhg@mail.gmail.com>
References: <20130613172408.GA5561@intel.com>
	<CAA9_cmf5y_z_XeX7N2Jno9uvUkrFK83RN1XrxTwVqZJnbdfEWA@mail.gmail.com>
	<CAA9_cmdr7gjrbBN8tV9LAH2JXzFiegLzLPOAHVg-9sP8p9HRqg@mail.gmail.com>
	<20130618173406.GB5054@intel.com>
	<CAA9_cmewUn1Gz_BJvmhuC46u_4b2xZ9SL-uEtefcaOg0ECBJhg@mail.gmail.com>
Date: Tue, 18 Jun 2013 23:01:19 +0300
Message-ID: <CAHp75Vf-bE1cYmj543U=Wk-=iEgTfpnezXSjPjHUiYdM8G-C+A@mail.gmail.com>
Subject: Re: [PATCH] dmatest: masking tests for channel capabilities
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Dan Williams <djbw@fb.com>
Cc: Jubin Mehta <jubin.mehta@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Jon Mason <jon.mason@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 10:16 PM, Dan Williams <djbw@fb.com> wrote:
> On Tue, Jun 18, 2013 at 10:34 AM, Jubin Mehta <jubin.mehta@intel.com> wrote:

>> Would you like to have some changes regarding the configuration
>> process for the module parameters of the dmatest?
>
> Yes, as a first step I would like to see a clean up of the the
> configuration parameters to be available via
> /sys/module/dmatest/parameters rather than /sys/kernel/debug/dmatest

Do  you mean to enable write access to them?

> As for "run" and "results" I see Andy's point that those are a bit
> awkward as parameters.  However, we do have trace points as a more
> general mechanism for dumping events and data to userspace.  If we had
> /sys/module/dmatest/parameters/run with a tracepoint for the result
> line does that get us everything we need for automation?  I can see
> more tracepoints beng added to get some perf metrics out of the tests.

I'm not familiar neither with perf, nor with tracepoints. Could you
elaborate and show here the scheme how it should work? How we will get
results? In what form?


--
With Best Regards,
Andy Shevchenko
