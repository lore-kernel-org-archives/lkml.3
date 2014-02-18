Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755060AbaBRKIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 05:08:35 -0500
Received: from know-smtprelay-omc-10.server.virginmedia.net ([80.0.253.74]:44151
	"EHLO know-smtprelay-omc-10.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039AbaBRKIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 05:08:32 -0500
X-Originating-IP: [81.99.114.138]
X-Spam: 0
X-Authority: v=2.1 cv=Qfbov6rv c=1 sm=1 tr=0 a=rTb9Q+mClrhkGV9Ah9iRIA==:117
 a=rTb9Q+mClrhkGV9Ah9iRIA==:17 a=N1CowNylAAAA:8 a=IkcTkHD0fZMA:10
 a=o3pxq7NaF3wA:10 a=Cb7S7D5HRXcxg4_HTmQA:9 a=QEXdDO2ut3YA:10
Message-ID: <1392718107.15829.12.camel@artifact>
Subject: Re: pci-3.14 resource alloc
From: Steven Newbury <steve@snewbury.org.uk>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Tue, 18 Feb 2014 10:08:27 +0000
In-Reply-To: <CAE9FiQV3H_nxH0gxcM0kW4uLm6b_qmHT9hRQUVY_4xPqjpvMtA@mail.gmail.com>
References: <1390773698.3450.12.camel@artifact>
	 <CAE9FiQVD=oVHM5WJgSJ5cNpXZ1NYy9E_pcGWfjKnmD9OZoHHsw@mail.gmail.com>
	 <1391643656.1067.1.camel@artifact>
	 <CAE9FiQV8jutRhaBicL4kjqVYd07FzHmNoSN3NxdA2TYvOc_KUg@mail.gmail.com>
	 <z9zi9m.n0zpxd.1hgeaud-qmf@mail.snewbury.org.uk>
	 <i9nn22.n0zs79.1hgeaud-qmf@mail.snewbury.org.uk>
	 <1392392764.3520.11.camel@devel-n900>
	 <CAE9FiQV3H_nxH0gxcM0kW4uLm6b_qmHT9hRQUVY_4xPqjpvMtA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-14 at 11:11 -0800, Yinghai Lu wrote:
> On Fri, Feb 14, 2014 at 7:46 AM, Steven Newbury <steve@snewbury.org.uk> wrote:
> >>
> >> Oh, never mind! I didn't notice pref_bar has been renamed to
> >> assign_pref_bars. It's working now! :)
> >
> > There's no pci bridge/bus hotplug though. Docking doesn't reveal the
> > pci-e->pci bridge or the (radeon) devices on the other side.
> 
> oh, no. could be other regression in linus tree or pci/next.
> 

Sorry about taking a while to get back to you.

Previously I needed the busn work to get it working, this was included
in the resource-alloc branch.  It never worked on mainline, the bridge
used to show up but never get scanned.  Now it's not showing up at all
on hotplug.  It could be a dock driver regression.

> Can you check if linus tree could reveal pci-e->pci bridge?
> 
I'll give it a go.

> or do you use iommu/dmar with the system?
> 
No, the only unusual option is I use pci=nocrs since the bios is
completely ignorant of support for 64bit BARs.   
> Thanks
> 
> Yinghai



