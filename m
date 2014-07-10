Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaGJLVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:21:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:31725 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbaGJLVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:21:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,637,1400050800"; 
   d="scan'208";a="455362456"
Message-ID: <1404991237.5102.100.camel@smile.fi.intel.com>
Subject: Re: [PATCH v1 3/5] crypto: qat - use seq_hex_dump() to dump buffers
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>, linux390@de.ibm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 10 Jul 2014 14:20:37 +0300
In-Reply-To: <53BD8A9F.4030409@intel.com>
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404919470-26668-4-git-send-email-andriy.shevchenko@linux.intel.com>
	 <53BD8A9F.4030409@intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-09 at 11:31 -0700, Tadeusz Struk wrote:
> On 07/09/2014 08:24 AM, Andy Shevchenko wrote:
> 
> > In this case it slightly changes the output, namely the four tetrads will be
> > output on one line.
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> It's ok, I can still read it.

It seems I miscalculated the tetrads. It should be 8 per line, correct?
In that case we could easily use 32 bytes per line and thus remove that
paragraph from commit message.

> Acked-by: Tadeusz Struk <tadeusz.struk@intel.com>

Thanks!


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

