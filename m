Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaJQV30 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 17:29:26 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52987 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750867AbaJQV3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 17:29:25 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 00/12] Add ACPI _DSD and unified device properties support
Date: Fri, 17 Oct 2014 23:49:45 +0200
Message-ID: <1787777.qrmnDZUWyu@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141017154007.GB29643@kroah.com>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <11223831.j9KAEfSQsY@vostro.rjw.lan> <20141017154007.GB29643@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 17, 2014 05:40:07 PM Greg Kroah-Hartman wrote:
> On Fri, Oct 17, 2014 at 02:01:33PM +0200, Rafael J. Wysocki wrote:
> > Hi Everyone,
> > 
> > Hving had a couple of chats with Grant and Arnd during LinuxCon EU/LPC, we
> > now have version 5 taking all feedback into account (hopefully).
> > 
> > Changes have been made to patch [02/12] and to patches [09-12/12], although
> > in patches [10-12/12] they are fairly minor.  I have retained the Greg's
> > ACK on patch [02/12], because it is essentially the same that have been
> > posted aleady and ACKed by him (Greg, please let me know if I shouldn't
> > do that) and all the ACKs on the remaining patches except for patch [09/12]
> > which is substantially different.  Still, if reviewers think that their
> > ACKs don't apply any more, please let me know and I'll remove them.
> 
> No objection from me to keep my ACK on those patches, thanks for asking.

Well, that's just fair IMO. :-)

Does [09/12] look good too in particular?

Rafael

