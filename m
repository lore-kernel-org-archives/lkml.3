Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaGKKPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 06:15:36 -0400
Received: from mail.sysmocom.de ([144.76.43.93]:37880 "EHLO mail.sysmocom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751664AbaGKKPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 06:15:34 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jul 2014 06:15:34 EDT
Date: Fri, 11 Jul 2014 12:08:22 +0200
From: Holger Hans Peter Freyther <holger@freyther.de>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Takashi Iwai <tiwai@suse.de>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH 02/10] xhci: 'noxhci_port_switch' kernel parameter
Message-ID: <20140711100822.GN22956@xiaoyu.lan>
References: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
 <1399566363-25837-3-git-send-email-mathias.nyman@linux.intel.com>
 <20140520010137.GA8146@kroah.com>
 <537B24B8.9050303@linux.intel.com>
 <s5ha9acbwwo.wl%tiwai@suse.de>
 <CAPcyv4gg164u8Dz0RtV4KjXkDyCMvuC92j6VopqTbA1Shp_3QA@mail.gmail.com>
 <20140520203432.GB30178@kroah.com>
 <CAPcyv4i4jTMMbZWWdb79bJ2f5OUaSin4BN_ukWmVcv7JCiup3g@mail.gmail.com>
 <20140524063945.GA14727@xiaoyu.lan>
 <CAPcyv4gwc7-keYsnLGBUkryPKSgK7AyLpTzjzmRXGaJ2ZVE=RA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4gwc7-keYsnLGBUkryPKSgK7AyLpTzjzmRXGaJ2ZVE=RA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 07:13:12AM -0700, Dan Williams wrote:

Good Afternoon,

> Let me see if I can achieve this with a debugfs interface so that
> 'noxhci_port_switch' does not become a permanent ABI per Greg's
> concern.

I wonder if there is another non-ABI option? Couldn't the ports
be unconditionall switched back to EHCI when unloading the xhci
module? I know it is just a workaround (but then again I don't
have any usb 3.0 devices). :)


cheers
	holger
