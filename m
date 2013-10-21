Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751624Ab3JUSrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 14:47:24 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31904 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab3JUSrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 14:47:23 -0400
Date: Mon, 21 Oct 2013 20:46:43 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, ian.campbell@citrix.com,
        ross.philipson@citrix.com, stefano.stabellini@eu.citrix.com,
        grub-devel@gnu.org, david.woodhouse@intel.com,
        richard.l.maliszewski@intel.com,
        xen-devel <xen-devel@lists.xenproject.org>, boris.ostrovsky@oracle.com,
        pjones@redhat.com, linux-kernel@vger.kernel.org, keir@xen.org
Subject: Re: EFI and multiboot2 devlopment work for Xen
Message-ID: <20131021184643.GC3626@debian70-amd64.local.net-space.pl>
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <52654A0602000078000FC611@nat28.tlf.novell.com>
 <20131021142347.GB4211@phenom.dumpdata.com>
 <5265584102000078000FC771@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5265584102000078000FC771@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 03:37:21PM +0100, Jan Beulich wrote:
> >>> On 21.10.13 at 16:23, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > On Mon, Oct 21, 2013 at 02:36:38PM +0100, Jan Beulich wrote:
> >> >>> On 21.10.13 at 14:57, Daniel Kiper <daniel.kiper@oracle.com> wrote:

[...]

> >> > What do you think about that?
> >> > Any comments, suggestions, objections?
> >>
> >> The complications here make it pretty clear to me that the
> >> GrUB2-less solution (or, if GruB2 absolutely has to be involved,
> >> its chain loading capability) I have been advocating continues
> >> to be the better (and, as said before, conceptually correct)
> >> model.
> >
> > However my understanding is that the general distro approach is
> > to use GRUB2 and I think we want to follow the mainstream on this.
> > Which means using GRUB2 and making sense of the myrid of patches
> > that each distro has.
>
> As does ours - and we simply use the chain loading mechanism as
> I'm told (and as I suggested - I'm only occasionally involved in the
> secure boot stuff).

Do you think about GRUB2 chainloader command?

Daniel
