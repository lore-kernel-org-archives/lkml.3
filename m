Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab3JVPWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:22:44 -0400
Received: from smtp.citrix.com ([66.165.176.89]:56727 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab3JVPWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:22:43 -0400
X-IronPort-AV: E=Sophos;i="4.93,548,1378857600"; 
   d="scan'208";a="66072084"
Message-ID: <1382455358.18283.31.camel@hastur.hellion.org.uk>
Subject: Re: [Xen-devel] EFI and multiboot2 devlopment work for Xen
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <grub-devel@gnu.org>, <keir@xen.org>, <david.woodhouse@intel.com>,
        <stefano.stabellini@eu.citrix.com>,
        Daniel Kiper <daniel.kiper@oracle.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xen.org>, Jan Beulich <JBeulich@suse.com>,
        Peter Jones <pjones@redhat.com>, <ross.philipson@citrix.com>,
        <boris.ostrovsky@oracle.com>, <richard.l.maliszewski@intel.com>
Date: Tue, 22 Oct 2013 16:22:38 +0100
In-Reply-To: <1382451868.18283.21.camel@hastur.hellion.org.uk>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
	 <20131021135437.GD1283@fenchurch.internal.datastacks.com>
	 <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
	 <1382433990.1657.66.camel@hastur.hellion.org.uk>
	 <5266620602000078000FCA48@nat28.tlf.novell.com>
	 <1382435127.1657.70.camel@hastur.hellion.org.uk>
	 <526668A502000078000FCA7B@nat28.tlf.novell.com>
	 <20131022134252.GA27302@phenom.dumpdata.com>
	 <1382449985.18283.12.camel@hastur.hellion.org.uk>
	 <20131022140947.GA17829@phenom.dumpdata.com>
	 <1382451868.18283.21.camel@hastur.hellion.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-22 at 15:24 +0100, Ian Campbell wrote:
> On Tue, 2013-10-22 at 10:09 -0400, Konrad Rzeszutek Wilk wrote:
> 
> > So it can be booted the same way as xen.efi. But my understanding is
> > that folks prefer a bootloader instead of loading the bzImage in an
> > NVRAM of a platform with pre-set parameters. Hence that mechanism
> > is not used by the majority of users.
> 
> My understanding is that they prefer a bootloader which can launch Linux
> as a PE/COFF image, i.e. the linuxefi thing.

What I'm trying to say here is that from the xen.efi or linux.efi point
of view it can't tell if it was launched directly from the EFI shell or
by some intermediate bootloader (i.e. by grub2's linuxefi command).

Ian.

