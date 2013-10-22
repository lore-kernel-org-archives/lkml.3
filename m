Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab3JVQZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:25:17 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42794 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3JVQZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:25:15 -0400
Date: Tue, 22 Oct 2013 12:24:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: "Woodhouse, David" <david.woodhouse@intel.com>,
        Jan Beulich <JBeulich@suse.com>,
        "ross.philipson@citrix.com" <ross.philipson@citrix.com>,
        "stefano.stabellini@eu.citrix.com" <stefano.stabellini@eu.citrix.com>,
        "grub-devel@gnu.org" <grub-devel@gnu.org>,
        "Maliszewski, Richard L" <richard.l.maliszewski@intel.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        Daniel Kiper <daniel.kiper@oracle.com>,
        Peter Jones <pjones@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keir@xen.org" <keir@xen.org>
Subject: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131022162412.GA19189@phenom.dumpdata.com>
References: <20131021185758.GD3626@debian70-amd64.local.net-space.pl>
 <1382433990.1657.66.camel@hastur.hellion.org.uk>
 <5266620602000078000FCA48@nat28.tlf.novell.com>
 <1382435127.1657.70.camel@hastur.hellion.org.uk>
 <526668A502000078000FCA7B@nat28.tlf.novell.com>
 <20131022134252.GA27302@phenom.dumpdata.com>
 <1382449985.18283.12.camel@hastur.hellion.org.uk>
 <7gf8ufyngxh0extp8a0ifnrp.1382451526144@email.android.com>
 <20131022145724.GA18763@phenom.dumpdata.com>
 <1382455307.18283.30.camel@hastur.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382455307.18283.30.camel@hastur.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 04:21:47PM +0100, Ian Campbell wrote:
> On Tue, 2013-10-22 at 10:57 -0400, Konrad Rzeszutek Wilk wrote:
> > That 'that' is a standard PE/COFF image?  Could you please point me
> > to the code that does that in GRUB2?
> 
> As I said earlier in the thread, it's a patch which is being carried by
> all the distros. It is not in upstream grub.
> 
> For instance here is Debian's version:
>         http://anonscm.debian.org/loggerhead/pkg-grub/trunk/grub/download/head:/linuxefi.patch-20130129060348-21bhrqmbqj52c28w-1/linuxefi.patch
>         

That is the same patch that I see in Fedora's GRUB2.

That patch _only_ boots PE/COFF images with the Linux x86/boot
format. It won't boot standard PE/COFF images.

> AIUI all the distros are carry basically the same patch.

I concur.
> 
> Ian.
> 
