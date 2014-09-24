Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaIXLEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 07:04:20 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:51337 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbaIXLEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 07:04:16 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 24 Sep 2014 13:01:42 +0200
From: Johan Hovold <johan@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Octavian Purdila <octavian.purdila@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alexandre Courbot <gnurou@gmail.com>, Wolfram Sang <wsa@the-dreams.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, johan@kernel.org,
        Daniel Baluta <daniel.baluta@intel.com>, laurentiu.palcu@intel.com,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v5 3/4] gpiolib: add irq_not_threaded flag to gpio_chip
Message-ID: <20140924110142.GC17019@localhost>
References: <1411158165-25794-1-git-send-email-octavian.purdila@intel.com>
 <1411158165-25794-4-git-send-email-octavian.purdila@intel.com>
 <CACRpkdbnXo9VhybkZeP7Z4b0pxCHorGJvbRw-dh_X0dWT2iC8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbnXo9VhybkZeP7Z4b0pxCHorGJvbRw-dh_X0dWT2iC8g@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:54:51AM +0200, Linus Walleij wrote:
> On Fri, Sep 19, 2014 at 10:22 PM, Octavian Purdila
> <octavian.purdila@intel.com> wrote:
> 
> > Some GPIO chips (e.g. the DLN2 USB adapter) have blocking get/set
> > operation but do not need a threaded irq handler.
> >
> > Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
> 
> Usually I don't apply patches adding interfaces with no users, but
> this seems very useful, so patch applied. I guess your driver will
> appear on v3.19+ so then you can rely on this having been merged
> for v3.18.

Octavian, please include this one in any future revision of you series
so that it is self-contained (at least until v3.18-rc1 is out)
nonetheless.

Thanks,
Johan
