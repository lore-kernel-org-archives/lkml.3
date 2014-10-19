Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaJSXLt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 19:11:49 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51163 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751579AbaJSXLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 19:11:45 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Grant Likely <grant.likely@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, devicetree@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 00/12] Add ACPI _DSD and unified device properties support
Date: Mon, 20 Oct 2014 01:32:06 +0200
Message-ID: <3905224.jRzYqJRRMv@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141018084959.23AB3C40A02@trevor.secretlab.ca>
References: <2660541.BycO7TFnA2@vostro.rjw.lan> <22806489.J415p1md4u@vostro.rjw.lan> <20141018084959.23AB3C40A02@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 18, 2014 10:49:59 AM Grant Likely wrote:
> On Sat, 18 Oct 2014 00:50 +0200
> , "Rafael J. Wysocki" <rjw@rjwysocki.net>
>  wrote:
> > On Friday, October 17, 2014 08:04:52 PM Arnd Bergmann wrote:
> > > 
> > > On October 17, 2014 2:01:33 PM CEST, "Rafael J. Wysocki" <rjw@rjwysocki.net> wrote:
> > > >Hi Everyone,
> > > >
> > > >Hving had a couple of chats with Grant and Arnd during LinuxCon EU/LPC,
> > > >we
> > > >now have version 5 taking all feedback into account (hopefully).
> > > 
> > > Awesome, that was really fast. I'm currently on my way his me in
> > > the train, replying from my phone, but it looks good now. I'll have a more
> > > detailed look next week but I'm definitely happy to see this go in (to next
> > > and 3.19) now, any details we still find can be fixed on top.
> > > 
> > > > In
> > > >short, if
> > > >we are passed a struct fwnode_handle pointer, we can get from it to the
> > > >appropriate device node pointer (either struct acpi_device or struct
> > > >device_node)
> > > >using container_of() after we've checked the type.  This is needed for
> > > >the code
> > > >that needs to access child nodes of a device in case when they don't
> > > >have
> > > >struct device representations (whatever the reason).  This has been
> > > >suggested
> > > >by Grant and pretty much everyone involved agrees that it's better that
> > > >the
> > > >alternatives presented so far.
> > > 
> > > Yes, it's nice enough that I now take back all the objections I had for the
> > > child accessory API.
> > 
> > Cool, thanks!
> > 
> > I've just refreshed the device-properties branch of the linux-pm.git tree
> > and it contains the current material now (including a couple of build
> > fixes reported by the autobuild robot in patches [02/12] and [09/12]).
> > 
> > My plan is to merge this into the linux-next branch when 3.18-rc1 is out.
> 
> Wait for my ack please, but I should be able to review it this weekend
> or on Monday. I'm actually reviewing now, but I'm on a plane near the
> end of the flight. As soon as I get on the ground SIGFAMILY will
> interrupt me for a bit. :-)

Sure, I won't be trying to push things that you don't like :-)

Rafael

