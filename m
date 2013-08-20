Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab3HTVDs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:03:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:64066 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab3HTVDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:03:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,922,1367996400"; 
   d="scan'208";a="365789177"
Message-ID: <1377032600.1758.12.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: ACPI vs Device Tree - moving forward
From: Darren Hart <dvhart@linux.intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux@roeck-us.net, hpa@zytor.com, linus.walleij@linaro.org,
        rjw@sisk.pl
Date: Tue, 20 Aug 2013 14:03:20 -0700
In-Reply-To: <20130820205712.GA22850@srcf.ucam.org>
References: <20130820192650.GA19470@srcf.ucam.org>
	 <1377031863.1758.10.camel@dvhart-mobl4.amr.corp.intel.com>
	 <20130820205712.GA22850@srcf.ucam.org>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4 (3.8.4-1.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 21:57 +0100, Matthew Garrett wrote:
> On Tue, Aug 20, 2013 at 01:51:03PM -0700, Darren Hart wrote:
> 
> > It seems to me that the only way to end up in a situation where the data
> > is reused by other OSes, is to go through a standards body. What about
> > attempting to standardize the _DSM method? I suppose the challenge then
> > is how do we standardize arbitrary data (which, of course, is an
> > oxymoron)...
> 
> Right. We could certainly spec the DT bindings that currently exist, but 
> the obvious pushback is that large chunks of it *are* already in ACPI - 
> a _PS0 method (which is ACPI for "Power up the device") that toggles a 
> GPIO pin, and then provides a different GPIO pin in the DT data, which 
> would we believe?

Right, understood.

> > The interesting thing about this to me is that many of these devices are
> > added after-the-fact (as add-on boards, for example). With the
> > MinnowBoard we are looking to provide this configuration data in an
> > EEPROM. Would it make sense for the device manufacturer (rather than the
> > base-board manufacturer) to define the key-value pairs for their
> > hardware?
> 
> Yes, hardware information that's on add-in boards should probably be 
> provided by the add-in board if it carries a ROM. This is trivial on 
> UEFI systems - you just need a UEFI driver for the board that can 
> construct an appropriate SSDT. It's more of a problem for non-UEFI ACPI 
> systems.

For development, those could pass the SSDT in via the initramfs
mechanism for Linux, but clearly a more integral solution would be
preferred.

> 
> > Sadly, I will not be in New Orleans and am unlikely to receive a Kernel
> > Summit invite, but I am planning be in Edinburgh and would like the
> > opportunity to participate in this discussion.
> 
> I'm not planning on being at kernel summit this year, so I think we'll 
> try to arrange something around that time but outside the event.
> 

Works for me :-) Please keep me on the list for that. That will become
my primary motivator for going.

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


