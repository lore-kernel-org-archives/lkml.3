Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaJGC34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 22:29:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54648 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaJGC3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 22:29:54 -0400
Date: Mon, 6 Oct 2014 19:28:55 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Grant Likely <grant.likely@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v4 00/13] Add ACPI _DSD and unified device properties
 support
Message-ID: <20141007022855.GA14466@kroah.com>
References: <2660541.BycO7TFnA2@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2660541.BycO7TFnA2@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 02:10:56AM +0200, Rafael J. Wysocki wrote:
> Hi Everyone,
> 
> This is version 4 of the unified device properties interface patchset.
> 
> The original cover letter from Mika is here:
> 
> http://marc.info/?l=devicetree&m=141087052200600&w=4
> 
> My cover letter for version 3 is here:
> 
> http://marc.info/?l=linux-acpi&m=141212903816560&w=4
> 
> One major change from the previous iteration is that now we will
> use the "compatible" property to match drivers to devices having
> "PRP0001" as their _HID, so for example the at25 driver doesn't
> have to add the extra ACPI match table as part of the conversion
> to the unified interface (patch [05/13] in this series).
> 
> The second major change is that I've split the driver core patch
> in two, where the first one ([02/13]) does not contain any stuff
> related to iterating over the child nodes of a given device.
> Accordingly, the whole patch series has been rearranged so that
> the relatively non-controversial patches [01-09/13], most of which
> have been ACKed already, go first and then goes the second driver
> core patch ([10/13]) and the other patches related to it.
> 
> In patches [10-13/13] I used the Arnd's suggestion to implement
> device_for_each_child_node() as a macro which makes the changes
> in patches [12-13/13] look more straightforward among other things.
> 
> I've retained the Greg's ACKs on patches [02/13] and [10/13], because
> the first of them is things ACKed by Greg only and the change in the
> second one is just an implementation detail in my opinion (Greg, please
> let me know if that's inappropriate).

No objection from me, looks good.

greg k-h
