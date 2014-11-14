Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422829AbaKNWdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:33:16 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61643 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934460AbaKNWdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:33:14 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
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
Date: Fri, 14 Nov 2014 23:54:13 +0100
Message-ID: <3115626.VVMxodDDvN@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACRpkdb-T42Bqtf7zvc+2om03hgu4j8twDUqmsE4dcKaPXB9Wg@mail.gmail.com>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com> <1433051.htaUTMPMBY@vostro.rjw.lan> <CACRpkdb-T42Bqtf7zvc+2om03hgu4j8twDUqmsE4dcKaPXB9Wg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 14, 2014 09:58:41 AM Linus Walleij wrote:
> On Mon, Nov 3, 2014 at 11:56 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Monday, November 03, 2014 02:22:10 PM Linus Walleij wrote:
> 
> >> With that change:
> >> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> >
> > OK, made the changes and added your Reviewed-by.
> >
> > One semi-related question though.  Alexandre ACKed the patch before, so
> > what did that mean from the GPIO subsystem's perspective?  Was the patch
> > approved, not approved, semi-approved?
> 
> It just means we are not always entirely aligned, it's not like
> Alexandre and I have meetings on the side and decide what to
> say, it's just these mails. I do trust him, I wouldn't get mad if it
> had been merged just wanted some polishing when I could get
> it...

I see, thanks!

Rafael

