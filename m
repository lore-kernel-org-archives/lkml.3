Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaBINc5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:32:57 -0500
Received: from know-smtprelay-omc-2.server.virginmedia.net ([80.0.253.66]:55762
	"EHLO know-smtprelay-omc-2.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbaBINc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:32:56 -0500
X-Originating-IP: [81.99.114.138]
X-Spam: 0
X-Authority: v=2.1 cv=L4GTQoj8 c=1 sm=1 tr=0 a=rTb9Q+mClrhkGV9Ah9iRIA==:117
 a=rTb9Q+mClrhkGV9Ah9iRIA==:17 a=N1CowNylAAAA:8 a=fopZr8Ys9qIA:10
 a=IkcTkHD0fZMA:10 a=i-oMMPxEfaEA:10 a=nlyIqT4kGldfwkGLb18A:9 a=QEXdDO2ut3YA:10
Message-ID: <1391952760.6036.10.camel@artifact>
Subject: Re: [Intel-gfx] agp/intel: can't ioremap flush page - no chipset
 flushing
From: Steven Newbury <steve@snewbury.org.uk>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Date: Sun, 09 Feb 2014 13:32:40 +0000
In-Reply-To: <1391952344.25424.4.camel@x220>
References: <1391886379.2669.11.camel@x41>
	 <CAKMK7uE6Gaq-ghgWJ+6Qyn7hrGzAMOHyGT9KQQJ+ij7omPV2Ew@mail.gmail.com>
	 <1391890927.1882.5.camel@x41>
	 <CAKMK7uFx2kksGgnuy9e0xiQRKpt=_+44O1V4wbX5yNBocvjBkg@mail.gmail.com>
	 <1391951759.6036.7.camel@artifact> <1391952344.25424.4.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.11.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 14:25 +0100, Paul Bolle wrote:
> On Sun, 2014-02-09 at 13:15 +0000, Steven Newbury wrote:
> > PCI resource allocation is undergoing some changes at the moment, it's
> > definitely a bug if the Flush Page isn't getting allocated.  I'm looking
> > forward to hopefully getting pci_bus_alloc_resource_fit() behaviour in
> > mainline, it will provide much better resource allocation in the 32 bit
> > PCI address space, and prevent problems like this from cropping up.
> > 
> > See Yinghai Lu's for-pci-res-alloc branch.
> > 
> > I've been carrying the changes in my local tree, but right now the
> > upstream PCI changes are quite extensive.  He's planning on rebasing the
> > branch soon.
> 
> Does this mean I might be better of not bisecting this just yet? Or are
> these changes targeted at v3.15 (or later)?
> 
> 
> Paul Bolle
> 

It's an aside really for now.  The bug has probably been introduced by
the recent pci allocation changes so it should be easier for you to
bisect, hopefully.


