Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab3EaH6A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 03:58:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:28829 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207Ab3EaH5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 03:57:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,777,1363158000"; 
   d="scan'208";a="310448480"
Message-ID: <1369987068.29283.238.camel@smile>
Subject: Re: [PATCH v3 3/5] gpio-langwell: use managed functions pcim_* and
 devm_*
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: David Cohen <david.a.cohen@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 31 May 2013 10:57:48 +0300
In-Reply-To: <CACRpkdYE+Gy5N62HWrEFiQ-eThMBm8xubLv7-C_XLMXxGNunEQ@mail.gmail.com>
References: <1369218014-28990-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1369218014-28990-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <CACRpkdYE+Gy5N62HWrEFiQ-eThMBm8xubLv7-C_XLMXxGNunEQ@mail.gmail.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-05-30 at 19:25 +0200, Linus Walleij wrote: 
> On Wed, May 22, 2013 at 12:20 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
> 
> > This makes the error handling much more simpler than open-coding everything and
> > in addition makes the probe function smaller an tidier.
> >
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Applied with Mika's ACK.
> 
> I had to rebase this thing since there was a patch removing the line
> setting platform data to NULL on remove(), check that I did the right
> thing in the result.

Yes, that is correct. Thanks!

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
