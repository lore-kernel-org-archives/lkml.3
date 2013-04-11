Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761886Ab3DKWgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 18:36:09 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56573 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab3DKWgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 18:36:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] gpiolib-acpi: introduce acpi_get_gpio_by_index() helper
Date: Fri, 12 Apr 2013 00:43:54 +0200
Message-ID: <91057740.Ix5vA2gAR4@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc6+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CACRpkdZKnLJbEqiWBmmTC+9yeSYgXryG0Na3BXqo1We1mRyTAg@mail.gmail.com>
References: <1364986614-15711-1-git-send-email-mika.westerberg@linux.intel.com> <CACRpkdZKnLJbEqiWBmmTC+9yeSYgXryG0Na3BXqo1We1mRyTAg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 12, 2013 12:33:55 AM Linus Walleij wrote:
> On Wed, Apr 3, 2013 at 12:56 PM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > Instead of open-coding ACPI GPIO resource lookup in each driver, we provide
> > a helper function analogous to Device Tree version that allows drivers to
> > specify which GPIO resource they are interested (using an index to the GPIO
> > resources). The function then finds out the correct resource, translates
> > the ACPI GPIO number to the corresponding Linux GPIO number and returns
> > that.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Patch applied with Rafael's ACK and pushed.

Thanks a lot Linus!

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
