Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934928Ab3GWWtk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:49:40 -0400
Received: from know-smtprelay-omc-1.server.virginmedia.net ([80.0.253.65]:53634
	"EHLO know-smtprelay-omc-1.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934582Ab3GWWtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:49:36 -0400
X-Originating-IP: [81.99.114.138]
X-Spam: 0
X-Authority: v=2.0 cv=A800pNqG c=1 sm=1 a=rTb9Q+mClrhkGV9Ah9iRIA==:17
 a=IkcTkHD0fZMA:10 a=xqWC_Br6kY4A:10 a=N1CowNylAAAA:8 a=5LiWbU99JdegsuGb7pUA:9
 a=QEXdDO2ut3YA:10 a=rTb9Q+mClrhkGV9Ah9iRIA==:117
Message-ID: <1374619769.316.1.camel@artifact>
Subject: Re: Linux 3.11-rc2
From: Steven Newbury <steve@snewbury.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        James Hogan <james@albanarts.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kamal Mostafa <kamal@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Date: Tue, 23 Jul 2013 23:49:29 +0100
In-Reply-To: <2081090.JJVTShTh7K@vostro.rjw.lan>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	 <1943327.gJaLv781Zb@vostro.rjw.lan> <1374601675.29964.15.camel@artifact>
	 <2081090.JJVTShTh7K@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 23:24 +0200, Rafael J. Wysocki wrote:
> On Tuesday, July 23, 2013 06:47:55 PM Steven Newbury wrote:
> > On Mon, 2013-07-22 at 21:56 +0200, Rafael J. Wysocki wrote:
> > > On Monday, July 22, 2013 06:16:20 PM Matthew Garrett wrote:
> > > > On Mon, 2013-07-22 at 15:02 +0200, Rafael J. Wysocki wrote:
> > > > 
> > > > > In the meantime I received a report from Steven Newbury that these changes
> > > > > broke things for him too, so we need to revert commits 8c5bd7a and efaa14c.
> > > > > The other two commits in the series should be benign.
> > > > 
> > > > Could you let me know the details of this problem?
> > > 
> > > Steven, can you please describe the problem you're seeing to Matthew and
> > > the other people on the list?
> > > 
> > > Rafael
> > > 
> > 
> > Before the changes backlight was working fine using the ACPI method: 
> > /sys/class/backlight/acpi_video0/ is present and the keyboard function keys
> > control brightness with notifications working in GNOME.
> > 
> > In the code as was present in the linux-pm/bleeding-edge tree I would
> > encounter a hard lockup on keyboard brightness trigger.  This also occurred with
> > the code as it initially hit mainline, but a later commit fixed the crash*, but
> > resulted in no backlight controls being available at all.
> > /sys/class/backlight  is empty.
> > 
> > *not actually sure if /sys/class/backlight contained anything before this
> 
> Hmm.  Which commit fixed the crash for you?
> 
> Rafael
> 

I'll see if I can build a broken kernel tomorrow, after backing up! ;-)

