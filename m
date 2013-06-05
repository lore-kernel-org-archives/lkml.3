Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093Ab3FEWjJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:39:09 -0400
Received: from moeglingen.blank.eu.org ([82.139.201.30]:55543 "EHLO
	mail.waldi.eu.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757840Ab3FEWjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 18:39:06 -0400
X-Greylist: delayed 510 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Jun 2013 18:39:06 EDT
Date: Thu, 6 Jun 2013 00:30:32 +0200
From: Bastian Blank <waldi@debian.org>
To: debian-kernel@lists.debian.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>
Subject: Re: getting allwinner SoC support upstream (was Re: Uploading linux
 (3.9.4-1))
Message-ID: <20130605223031.GB22277@mail.waldi.eu.org>
Mail-Followup-To: debian-kernel@lists.debian.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux on small ARM machines <arm-netbook@lists.phcomp.co.uk>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 08:46:30PM +0100, Luke Kenneth Casson Leighton wrote:
>  to begin to describe the problem in getting allwinner soc source code
> upstream is this: not only do we have the usual "let's get it out the
> door as fast as possible" learning curve of a very young, very new and
> bewilderingly-successful fabless SoC company, but we also have a
> completely new type of very successful and comprehensive
> device-tree-like dynamic configuration system to deal with, which
> allwinner have called "fex" [*1].

IBM for example pushs the code into the kernel before the silicon is
even finished. Once a driver was removed because the project was
scrapped before it reached the customers. Arm did the same for the 64bit
variant of the architecture.

Are the turn around times for the allwinner SoC stuff really shorter
then two kernel releases?

>  basically at the time when device-tree was being thought of,
> allwinner needed something that they could *right then* - not waiting
> for developers to finish device-tree - they needed to be able to
> reconfigure their customer's kernels *without* needing a recompile.
> so they invented the script.fex system, which is a simple config.ini
> file-format, compile it to binary, and get the bootloader to upload it
> to memory and read it.

So it was invented over five years ago? What did you do in the last two
years since it was finished in all its glory?

> what's the point of mentioning this?

Obviously nothing, as the decision stands.

> well, the point is: the expectation of the linux kernel developers is
> that Everyone Must Convert To DeviceTree.  implicitly behind that is,
> i believe, an expectation that if you *don't* convert to Device Tree,
> you can kiss upstream submission goodbye.  and, in allwinner's case,
> that's simply not going to happen.

Yes. Our project, our rules. If you don't like them, go away.

> add to this the fact that they've already taken *five* near-identical
> copies of each version of their drivers (for sun3i up to sun7i) - if
> you do a recursive diff in the drivers/usb/sun7i_usb and
> drivers/usb/sun4i_usb directories, the discrepancies are negligeable
> (and are in many cases a regression, reintroducing known or new
> bugs!), you can start to see that they simply have no idea how to work
> with the free software community (they're too busy) and that they're
> not really about to start, either.

Send patches as everyone else.

Bastian

-- 
I've already got a female to worry about.  Her name is the Enterprise.
		-- Kirk, "The Corbomite Maneuver", stardate 1514.0
