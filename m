Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab3HTVDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:03:11 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52045 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab3HTVDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:03:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Darren Hart <dvhart@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux@roeck-us.net, hpa@zytor.com,
        linus.walleij@linaro.org
Subject: Re: ACPI vs Device Tree - moving forward
Date: Tue, 20 Aug 2013 23:13:44 +0200
Message-ID: <24185074.ohppXxCEri@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130820205712.GA22850@srcf.ucam.org>
References: <20130820192650.GA19470@srcf.ucam.org> <1377031863.1758.10.camel@dvhart-mobl4.amr.corp.intel.com> <20130820205712.GA22850@srcf.ucam.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 20, 2013 09:57:13 PM Matthew Garrett wrote:
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
> 
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
> 
> > Sadly, I will not be in New Orleans and am unlikely to receive a Kernel
> > Summit invite, but I am planning be in Edinburgh and would like the
> > opportunity to participate in this discussion.
> 
> I'm not planning on being at kernel summit this year, so I think we'll 
> try to arrange something around that time but outside the event.

Well, I'm attending the KS, however, so I'd prefer them not to conflict
with each other if possible.

Thanks,
Rafael

