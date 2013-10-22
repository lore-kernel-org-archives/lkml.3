Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab3JVQJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:09:49 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:45302 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab3JVQII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:08:08 -0400
X-IronPort-AV: E=Sophos;i="4.93,549,1378857600"; 
   d="scan'208";a="63427850"
Message-ID: <1382458083.18283.34.camel@hastur.hellion.org.uk>
Subject: Re: EFI and multiboot2 devlopment work for Xen
From: Ian Campbell <ian.campbell@citrix.com>
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: "Woodhouse, David" <david.woodhouse@intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Jan Beulich" <JBeulich@suse.com>,
        "ross.philipson@citrix.com" <ross.philipson@citrix.com>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>,
        "Maliszewski, Richard L" <richard.l.maliszewski@intel.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        Peter Jones <pjones@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keir@xen.org" <keir@xen.org>
Date: Tue, 22 Oct 2013 17:08:03 +0100
In-Reply-To: <20131022160146.GH3626@debian70-amd64.local.net-space.pl>
References: <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
	 <1382433990.1657.66.camel@hastur.hellion.org.uk>
	 <5266620602000078000FCA48@nat28.tlf.novell.com>
	 <1382435127.1657.70.camel@hastur.hellion.org.uk>
	 <526668A502000078000FCA7B@nat28.tlf.novell.com>
	 <20131022134252.GA27302@phenom.dumpdata.com>
	 <20131022144309.GA18547@phenom.dumpdata.com>
	 <1382455537.8512.11.camel@shinybook.infradead.org>
	 <20131022153258.GA12260@srcf.ucam.org>
	 <1382456560.8512.24.camel@shinybook.infradead.org>
	 <20131022160146.GH3626@debian70-amd64.local.net-space.pl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-22 at 18:01 +0200, Daniel Kiper wrote:
> On Tue, Oct 22, 2013 at 03:42:42PM +0000, Woodhouse, David wrote:
> > On Tue, 2013-10-22 at 16:32 +0100, Matthew Garrett wrote:
> > >
> > > There are two problems with this:
> > >
> > > 1) The kernel will only boot if it's signed with a key in db, not a key
> > > in MOK.
> > > 2) grub will read the kernel, but the kernel will have to read the
> > > initramfs using EFI calls. That means your initramfs must be on a FAT
> > > partition.
> > >
> > > If you're happy with those limitations then just use the chainloader
> > > command. If you're not, use the linuxefi command.
> >
> > Well, we're talking about booting the Xen hypervisor aren't we?
> >
> > So yes, there are reasons the Linux kernel uses the 'boot stub' the way
> > it does, but I'm not sure we advocate that Xen should emulate that in
> > all its 'glory'?
> 
> Right, I think that sensible mixture of multiboot2 protocol (it is needed
> to pass at least modules list to Xen; IIRC, linuxefi uses Linux Boot protocol
> for it) with extension proposed by Vladimir and something similar to linuxefi
> command will solve our problem (I proposed it in my first email). Users which
> do not need SB may use upstream GRUB2 and others could use
> 'multiboot2efi extension'.

Are you (going to be) in Edinburgh? Matthew was just explaining a bunch
of this stuff to me, it might be useful for you to get it from the
horses mouth instead of laundered through my brain (which is a bit
addled afterwards ;-)).

Ian.

