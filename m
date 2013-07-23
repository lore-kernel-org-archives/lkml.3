Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122Ab3GWVOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 17:14:34 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36360 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758036Ab3GWVOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 17:14:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Steven Newbury <steve@snewbury.org.uk>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        James Hogan <james@albanarts.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kamal Mostafa <kamal@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: Linux 3.11-rc2
Date: Tue, 23 Jul 2013 23:24:33 +0200
Message-ID: <2081090.JJVTShTh7K@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1374601675.29964.15.camel@artifact>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com> <1943327.gJaLv781Zb@vostro.rjw.lan> <1374601675.29964.15.camel@artifact>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 23, 2013 06:47:55 PM Steven Newbury wrote:
> On Mon, 2013-07-22 at 21:56 +0200, Rafael J. Wysocki wrote:
> > On Monday, July 22, 2013 06:16:20 PM Matthew Garrett wrote:
> > > On Mon, 2013-07-22 at 15:02 +0200, Rafael J. Wysocki wrote:
> > > 
> > > > In the meantime I received a report from Steven Newbury that these changes
> > > > broke things for him too, so we need to revert commits 8c5bd7a and efaa14c.
> > > > The other two commits in the series should be benign.
> > > 
> > > Could you let me know the details of this problem?
> > 
> > Steven, can you please describe the problem you're seeing to Matthew and
> > the other people on the list?
> > 
> > Rafael
> > 
> 
> Before the changes backlight was working fine using the ACPI method: 
> /sys/class/backlight/acpi_video0/ is present and the keyboard function keys
> control brightness with notifications working in GNOME.
> 
> In the code as was present in the linux-pm/bleeding-edge tree I would
> encounter a hard lockup on keyboard brightness trigger.  This also occurred with
> the code as it initially hit mainline, but a later commit fixed the crash*, but
> resulted in no backlight controls being available at all.
> /sys/class/backlight  is empty.
> 
> *not actually sure if /sys/class/backlight contained anything before this

Hmm.  Which commit fixed the crash for you?

Rafael

