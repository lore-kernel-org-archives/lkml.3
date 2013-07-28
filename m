Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab3G1NvH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 09:51:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43937 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3G1NvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 09:51:05 -0400
Date: Sun, 28 Jul 2013 15:51:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Wyborny, Carolyn" <carolyn.wyborny@intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Greg KH <greg@kroah.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Allan, Bruce W" <bruce.w.allan@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Rose, Gregory V" <gregory.v.rose@intel.com>,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Dave, Tushar N" <tushar.n.dave@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: Re: /sys/module/pcie_aspm/parameters/policy not writable?
Message-ID: <20130728135103.GC5382@amd.pavel.ucw.cz>
References: <20130709012611.GA22371@amd.pavel.ucw.cz>
 <20130709041321.GA30555@kroah.com>
 <20130709094906.GA3870@amd.pavel.ucw.cz>
 <20130709101039.GA4479@amd.pavel.ucw.cz>
 <CAErSpo57qjTkGbNK5qLzJcKuqBGK5=R=raEdyL6M1d5O=FkK_Q@mail.gmail.com>
 <20130710132950.GA3684@amd.pavel.ucw.cz>
 <CAErSpo5ig3bxZ3hBUUrzTdc=YqHy7cBGBxOLru4NYdyOOR+W5w@mail.gmail.com>
 <20130712111121.GB3515@amd.pavel.ucw.cz>
 <CAErSpo6NYZNHyV9xh2wRSQp72-dxg+FrFW4XrjE5Ps=bW6AGCw@mail.gmail.com>
 <9BBC4E0CF881AA4299206E2E1412B6264F921872@ORSMSX102.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9BBC4E0CF881AA4299206E2E1412B6264F921872@ORSMSX102.amr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-07-24 15:19:55, Wyborny, Carolyn wrote:
> > -----Original Message-----
> > From: Bjorn Helgaas [mailto:bhelgaas@google.com]
> [..}
> >
> > We *could* consider something like this, since its scope is limited.
> > But since the problem also occurs with Windows, it's pretty likely that there's a
> > BIOS update to fix it.  I notice on the X60 support page that there are several
> > versions newer than what you're running.
> > 
> > Bjorn
> 
> I believe that some BIOS don't allow user control on this feature, thus we end up unable to disable it from driverspace or from userspace, with the method we use today in this scenario.
> 
> I have a patch almost ready that attempts to disable using the pci_disable_link_state() call but then checks again to see if its still enabled and if not, then changes the pci config space on the devices on either side of the pcie link.  I plan to send it to this list for Pavel's testing as soon as I have it finished, at worst end of week.
> 

If there's patch, I'll gladly try it :-). Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
