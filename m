Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaACSOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 13:14:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbaACSOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 13:14:31 -0500
Message-ID: <1388772869.5769.1.camel@linux-fkkt.site>
Subject: Re: [PATCH v1] xhci: Switch Intel Lynx Point ports to EHCI on
 shutdown
From: Oliver Neukum <oneukum@suse.de>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Denis Turischev <denis.turischev@compulab.co.il>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, dashing.meng@gmail.com,
        Niklas Schnelle <niklas@komani.de>, Giorgos <ganastasiouGR@gmail.com>,
        art1@vhex.net
Date: Fri, 03 Jan 2014 19:14:29 +0100
In-Reply-To: <20140103000334.GE9621@xanatos>
References: <52B31EDA.60908@compulab.co.il>
	 <52B327D5.3080805@compulab.co.il> <20131219182110.GC3573@xanatos>
	 <52B41EC7.1070704@compulab.co.il> <20131220234547.GC2835@xanatos>
	 <52B69925.8030409@compulab.co.il> <20140103000334.GE9621@xanatos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-02 at 16:03 -0800, Sarah Sharp wrote:
> That means your system worked fine in 3.13-rc3 (when the quirk was
> applied broadly), but won't work for 3.13-rc6 (when the quirk was
> narrowed to HP machines).  So we need the quirk to apply to your
> systems
> as well.
> 
> ISTR that the other folks on Cc (Meng, Niklas, Giorgos, and Art) all
> had
> systems that broke when commit
> 638298dc66ea36623dbc2757a24fc2c4ab41b016
> was introduced.  For those systems, what vendor was the system, and
> what
> BIOS was it running?
> 
> Takashi, did the HP systems that needed the quirk have a Phoenix BIOS?
> 
> Denis, do all of Compulab's Haswell systems reboot on shutdown?  Are
> they all running a Phoenix BIOS?  Can you send me the output of `sudo
> lspci -vvv -s` for the xHCI host?
> 
> Basically, I'm trying to find a common variable to key off.  I suspect
> BIOS vendor is probably the right thing, instead of system vendor.

The BIOS vendor on HP systems is "Hewlett-Packard"
I guess the hope for a single common denominator is futile.
It'll have to be a list.

	Regards
		Oliver


