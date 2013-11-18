Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab3KRN7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 08:59:44 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33438 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3KRN7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 08:59:38 -0500
Date: Mon, 18 Nov 2013 13:59:26 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andreas Werner <wernerandy@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Black screen with GMA500 driver on Atom E680 (invalid VBT
 signature)
Message-ID: <20131118135926.650e9904@alan.etchedpixels.co.uk>
In-Reply-To: <20131116092838.GA2564@thinkpad.fritz.box>
References: <20131113183418.GA1593@thinkpad.fritz.box>
	<20131114135209.0a8a15ff@alan.etchedpixels.co.uk>
	<20131114182523.GA2133@thinkpad.fritz.box>
	<20131114205758.78c0788d@alan.etchedpixels.co.uk>
	<20131116092838.GA2564@thinkpad.fritz.box>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> if i dump the memory on 0xFC of the config space, there is just some from the
> BIOS vendor with a BIOS Version, but nothing like $GCT.

Ok

> In the Datasheet the 0xFC is described as "storage" does it mean there should
> be the settings for the Graphic like VBT?
> I did not find more information abaout GCT and how to implement it.

Its one place it can be. I don't believe there is any public
documentation.

> The board uses sdvo->vga for the output, the second board
> uses sdvo->DVI and LVDS but there is always a  black screen on each
> output interface. So i think there is wether a VBT not a GCT.

Fair enough. The current state is basically that some E600T devices happen
to work on certain ports (the logic is similar enough). If you've got one
that doesn't then you are basically on your own. 

The last "official" Intel out of tree driver is EMGD 1.18 which supports
Fedora 14 and a couple of other obsolete distros. It may be possible to
use the open bits of that as a basis of adding E680T support but it's
probably a couple of months work for someone sufficiently insa^Wmotivated.

Alan
