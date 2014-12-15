Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaLOKUx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:20:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:50242 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbaLOKUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:20:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,579,1413270000"; 
   d="scan'208";a="654039627"
Message-ID: <1418638849.17201.65.camel@linux.intel.com>
Subject: Re: [PATCH 2/2] Input: gpio_keys - replace timer and workqueue with
 delayed workqueue
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Laxman Dewangan <ldewangan@nvidia.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 15 Dec 2014 12:20:49 +0200
In-Reply-To: <20141213190926.GD22702@dtor-ws>
References: <20141208071930.GA20802@dtor-ws>
	 <20141208072124.GA21031@dtor-ws>
	 <1418236376.17201.57.camel@linux.intel.com>
	 <20141213190926.GD22702@dtor-ws>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-12-13 at 11:09 -0800, Dmitry Torokhov wrote:
> Hi Andy,
> 
> On Wed, Dec 10, 2014 at 08:32:56PM +0200, Andy Shevchenko wrote:
> > On Sun, 2014-12-07 at 23:21 -0800, Dmitry Torokhov wrote:
> > > We do not need to roll our own implementation of delayed work now that we
> > > have proper implementation of mod_delayed_work.
> > > 
> > > For interrupt-only driven buttons we retain the timer, but we rename
> > > it to release_timer to better reflect its purpose.
> > 
> > At least it doesn't break the driver on Intel Medfield device.
> > 
> > Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Thank you for testing it. Assume it is for both patches, right?

Right.

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

