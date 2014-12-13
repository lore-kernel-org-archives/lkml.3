Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaLMTJd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 14:09:33 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:62993 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbaLMTJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 14:09:32 -0500
Date: Sat, 13 Dec 2014 11:09:26 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-input@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Laxman Dewangan <ldewangan@nvidia.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Input: gpio_keys - replace timer and workqueue with
 delayed workqueue
Message-ID: <20141213190926.GD22702@dtor-ws>
References: <20141208071930.GA20802@dtor-ws>
 <20141208072124.GA21031@dtor-ws>
 <1418236376.17201.57.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418236376.17201.57.camel@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On Wed, Dec 10, 2014 at 08:32:56PM +0200, Andy Shevchenko wrote:
> On Sun, 2014-12-07 at 23:21 -0800, Dmitry Torokhov wrote:
> > We do not need to roll our own implementation of delayed work now that we
> > have proper implementation of mod_delayed_work.
> > 
> > For interrupt-only driven buttons we retain the timer, but we rename
> > it to release_timer to better reflect its purpose.
> 
> At least it doesn't break the driver on Intel Medfield device.
> 
> Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Thank you for testing it. Assume it is for both patches, right?

-- 
Dmitry
