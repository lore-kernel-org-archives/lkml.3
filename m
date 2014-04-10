Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030259AbaDJLCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 07:02:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:29577 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030213AbaDJLCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 07:02:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,833,1389772800"; 
   d="scan'208";a="518254095"
Message-ID: <1397127659.11914.94.camel@smile.fi.intel.com>
Subject: Re: [RFC PATCH 0/5] add gpio_chip_ops to hold GPIO operations
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 10 Apr 2014 14:00:59 +0300
In-Reply-To: <534665B1.9090207@collabora.co.uk>
References: <1396981215-24888-1-git-send-email-javier.martinez@collabora.co.uk>
	 <CAAVeFu+XV_wy9JzewGs0bcSA-ivQg-kzygMh_kt434rsYRQwHQ@mail.gmail.com>
	 <534665B1.9090207@collabora.co.uk>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-10 at 11:34 +0200, Javier Martinez Canillas wrote:
> On 04/10/2014 09:36 AM, Alexandre Courbot wrote:
> > 
> > "Since having the operations" maybe?
> > 
> 
> Yes, since I'm not a native english speaker I sometimes miss some obvious
> grammatical errors. I'll fix those when posting the final version with all the
> drivers converted.

JFYI: there is nice project called codespell [1].

[1] git://github.com/lucasdemarchi/codespell.git

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy

