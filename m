Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaKQXKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:10:24 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50639 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753269AbaKQXKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:10:22 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] ACPI / GPIO: Driver GPIO mappings for ACPI GPIOs
Date: Tue, 18 Nov 2014 00:31:23 +0100
Message-ID: <3901050.KoSeMVLBPy@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAAVeFuLV2yR1tmxX-HicupqgwUYj5HzqvSoi0Bq3V7aVpvf9bg@mail.gmail.com>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com> <CACRpkdb-T42Bqtf7zvc+2om03hgu4j8twDUqmsE4dcKaPXB9Wg@mail.gmail.com> <CAAVeFuLV2yR1tmxX-HicupqgwUYj5HzqvSoi0Bq3V7aVpvf9bg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 17, 2014 01:28:54 PM Alexandre Courbot wrote:
> On Fri, Nov 14, 2014 at 5:58 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> > On Mon, Nov 3, 2014 at 11:56 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >> On Monday, November 03, 2014 02:22:10 PM Linus Walleij wrote:
> >
> >>> With that change:
> >>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> >>
> >> OK, made the changes and added your Reviewed-by.
> >>
> >> One semi-related question though.  Alexandre ACKed the patch before, so
> >> what did that mean from the GPIO subsystem's perspective?  Was the patch
> >> approved, not approved, semi-approved?
> >
> > It just means we are not always entirely aligned, it's not like
> > Alexandre and I have meetings on the side and decide what to
> > say, it's just these mails. I do trust him, I wouldn't get mad if it
> > had been merged just wanted some polishing when I could get
> > it...
> 
> In case of conflicting feedback between me and Linus, it goes without
> saying that Linus' opinion should prevail. I am trying to help a bit
> and take some of the burden off his shoulders, but have neither his
> skill nor his experience (which shows when you compare our patch
> reviews). So for important stuff it is a good idea to wait until both
> of us give a ack - the most likely conflict scenario being that I give
> a pass overlooking something that Linus will catch.

Thanks for the clarification!

Rafael

