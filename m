Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3AVKZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:25:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830Ab3AVKZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:25:36 -0500
Date: Tue, 22 Jan 2013 11:25:29 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: simon@mungewell.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] HID: add ThingM blink(1) USB RGB LED support
In-Reply-To: <1270977623.602972.1358796715392.JavaMail.root@mail.savoirfairelinux.com>
Message-ID: <alpine.LNX.2.00.1301221124450.20374@pobox.suse.cz>
References: <1270977623.602972.1358796715392.JavaMail.root@mail.savoirfairelinux.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jan 2013, Vivien Didelot wrote:

> > > +++ b/Documentation/ABI/testing/sysfs-driver-hid-blink1
> > > @@ -0,0 +1,23 @@
> > > +What:		/sys/class/leds/blink(1)::<serial>/rgb
> > > +Date:		January 2013
> > > +Contact:	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> > > +Description:	The ThingM blink(1) is an USB RGB LED. The color
> > > notation is
> > > +		3-byte hexadecimal. Read this attribute to get the last set
> > > +		color. Write the 24-bit hexadecimal color to change the current
> > > +		LED color. The default color is full white (0xFFFFFF).
> > > +		For instance, set the color to green with: echo 00FF00 > rgb
> > > +
> > 
> > Shouldn't the name presented in the sys/class/leds directories change
> > appropriately too?
> 
> The directory name for the device under /sys/class/leds is "blink(1)::<serial>",
> where <serial> is the last 4 digits of the device serial number (the first 4
> digits are always the same: "1A00"). For instance, "blink(1)::1234".
> Let me know if I misunderstood your question.

I believe that Simon's (valid) observation is that the sysfs path should 
reflect the name change, i.e. something along the lines of 
/sys/class/leds/thingm-blink:<serial>   ... ?

-- 
Jiri Kosina
SUSE Labs
