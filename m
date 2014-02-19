Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaBSJL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 04:11:57 -0500
Received: from know-smtprelay-omc-10.server.virginmedia.net ([80.0.253.74]:53127
	"EHLO know-smtprelay-omc-10.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758AbaBSJLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 04:11:51 -0500
X-Originating-IP: [81.99.114.138]
X-Spam: 0
X-Authority: v=2.1 cv=Qfbov6rv c=1 sm=1 tr=0 a=rTb9Q+mClrhkGV9Ah9iRIA==:117
 a=rTb9Q+mClrhkGV9Ah9iRIA==:17 a=N1CowNylAAAA:8 a=IkcTkHD0fZMA:10
 a=o3pxq7NaF3wA:10 a=yxE7Le_3lCs2UivTqn4A:9 a=QEXdDO2ut3YA:10
Message-ID: <1392801107.15829.36.camel@artifact>
Subject: Re: pci-3.14 resource alloc
From: Steven Newbury <steve@snewbury.org.uk>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 19 Feb 2014 09:11:47 +0000
In-Reply-To: <7133100.UJBc8oSLiz@vostro.rjw.lan>
References: <1390773698.3450.12.camel@artifact>
	 <1392718107.15829.12.camel@artifact>
	 <CAE9FiQXUhvG2Jub3sbBxyCERVbt-L22+O+mcZ_HWEVQ_QaRawA@mail.gmail.com>
	 <7133100.UJBc8oSLiz@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-18 at 23:29 +0100, Rafael J. Wysocki wrote:
> On Tuesday, February 18, 2014 10:52:54 AM Yinghai Lu wrote:
> > On Tue, Feb 18, 2014 at 2:08 AM, Steven Newbury <steve@snewbury.org.uk> wrote:
> > >> >
> > >> > There's no pci bridge/bus hotplug though. Docking doesn't reveal the
> > >> > pci-e->pci bridge or the (radeon) devices on the other side.
> > >>
> > >> oh, no. could be other regression in linus tree or pci/next.
> > >>
> > >
> > > Previously I needed the busn work to get it working, this was included
> > > in the resource-alloc branch.  It never worked on mainline, the bridge
> > > used to show up but never get scanned.  Now it's not showing up at all
> > > on hotplug.  It could be a dock driver regression.
> > 
> > I had the busn_res_alloc patches in the branch.
> > 
> > There is some changes about acpi dock driver from Rafael in recent
> > kernels. Maybe Rafael could suggest which commit could cause problem,
> > then you could try revert them on top of branch.
> 
> I kind of suspect what might have caused them, but that particular thing
> would not be easy to revert.
> 
> Steven, what was the last kernel in which the bridge showed up?
> 
> Did you test 3.14-rc3?
> 
> Rafael
> 

I'll try a few different kernels today and see when it last worked.  I
hadn't updated the machine since some 3.12-rc + my local patches so I've
no idea at the moment when it stopped working...


