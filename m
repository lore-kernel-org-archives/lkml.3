Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847Ab3GIJOP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 05:14:15 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34119 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab3GIJOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 05:14:08 -0400
Date: Tue, 9 Jul 2013 11:14:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, joe.lawrence@stratus.com,
        myron.stowe@redhat.com, bhelgaas@google.com
Subject: Re: /sys/module/pcie_aspm/parameters/policy not writable?
Message-ID: <20130709091406.GA20470@amd.pavel.ucw.cz>
References: <20130709012611.GA22371@amd.pavel.ucw.cz>
 <20130709041321.GA30555@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130709041321.GA30555@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > My thinkpad has rather high ping latencies... and perhaps it is due to
> > PCIE ASPM.
> 
> Why would that be the problem?  The odds that the PCIE bus is the issue
> seems strange to me.

Well, I google a bit. Apparently, the issue is common on x60/t60
machine and was never fixed properly.

And indeed some patches point in that direction, in particular:

https://launchpadlibrarian.net/17463623/e1000e-0.4.1.7.diff

(It is from comment #27 here:

https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.22/+bug/42572

).

If you have any idea what else it could be...
									Pavel 
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
