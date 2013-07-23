Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933802Ab3GWVKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:10:52 -0400
Received: from know-smtprelay-omc-1.server.virginmedia.net ([80.0.253.65]:49034
	"EHLO know-smtprelay-omc-1.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757833Ab3GWVKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:10:50 -0400
X-Originating-IP: [81.99.114.138]
X-Spam: 0
X-Authority: v=2.0 cv=A800pNqG c=1 sm=1 a=rTb9Q+mClrhkGV9Ah9iRIA==:17
 a=IkcTkHD0fZMA:10 a=xqWC_Br6kY4A:10 a=N1CowNylAAAA:8 a=ux35a6gUWGjqjflHfRUA:9
 a=QEXdDO2ut3YA:10 a=rTb9Q+mClrhkGV9Ah9iRIA==:117
Message-ID: <1374613838.5355.5.camel@artifact>
Subject: Re: Linux 3.11-rc2
From: Steven Newbury <steve@snewbury.org.uk>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, James Hogan <james@albanarts.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kamal Mostafa <kamal@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Date: Tue, 23 Jul 2013 22:10:38 +0100
In-Reply-To: <1374609113.2641.2.camel@x230>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	 <5728692.GlhGgHY92H@vostro.rjw.lan> <1374516979.2641.0.camel@x230>
	 <1943327.gJaLv781Zb@vostro.rjw.lan> <1374601675.29964.15.camel@artifact>
	 <1374609113.2641.2.camel@x230>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 19:51 +0000, Matthew Garrett wrote:
> On Tue, 2013-07-23 at 18:47 +0100, Steven Newbury wrote:
> 
> > In the code as was present in the linux-pm/bleeding-edge tree I would
> > encounter a hard lockup on keyboard brightness trigger.  This also occurred with
> > the code as it initially hit mainline, but a later commit fixed the crash*, but
> > resulted in no backlight controls being available at all.
> > /sys/class/backlight  is empty.
> 
> This is an Intel system using the i915 driver?
> 

Yes, IVB i7-3840QM.  CLEVO W270EUQ.

