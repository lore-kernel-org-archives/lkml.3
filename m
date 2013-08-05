Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab3HERW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:22:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753028Ab3HERWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:22:25 -0400
Date: Mon, 5 Aug 2013 20:22:15 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <james.hogan@imgtec.com>, David Daney <ddaney.cavm@gmail.com>,
        linux-mips@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 1/3] mips/kvm: Improve code formatting in
 arch/mips/kvm/kvm_locore.S
Message-ID: <20130805172215.GC15901@redhat.com>
References: <1375388555-4045-1-git-send-email-ddaney.cavm@gmail.com>
 <1375388555-4045-2-git-send-email-ddaney.cavm@gmail.com>
 <51FFA5CD.3010406@imgtec.com>
 <20130805132157.GB3470@linux-mips.org>
 <20130805134326.GA15901@redhat.com>
 <20130805170610.GA17633@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805170610.GA17633@linux-mips.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 07:06:10PM +0200, Ralf Baechle wrote:
> On Mon, Aug 05, 2013 at 04:43:27PM +0300, Gleb Natapov wrote:
> > Date:   Mon, 5 Aug 2013 16:43:27 +0300
> > From: Gleb Natapov <gleb@redhat.com>
> > To: Ralf Baechle <ralf@linux-mips.org>
> > Cc: James Hogan <james.hogan@imgtec.com>, David Daney
> >  <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org, kvm@vger.kernel.org,
> >  Sanjay Lal <sanjayl@kymasys.com>, linux-kernel@vger.kernel.org, David
> >  Daney <david.daney@cavium.com>
> > Subject: Re: [PATCH 1/3] mips/kvm: Improve code formatting in
> >  arch/mips/kvm/kvm_locore.S
> > Content-Type: text/plain; charset=us-ascii
> > 
> > On Mon, Aug 05, 2013 at 03:21:57PM +0200, Ralf Baechle wrote:
> > > On Mon, Aug 05, 2013 at 02:17:01PM +0100, James Hogan wrote:
> > > 
> > > > 
> > > > On 01/08/13 21:22, David Daney wrote:
> > > > > From: David Daney <david.daney@cavium.com>
> > > > > 
> > > > > No code changes, just reflowing some comments and consistently using
> > > > > tabs and spaces.  Object code is verified to be unchanged.
> > > > > 
> > > > > Signed-off-by: David Daney <david.daney@cavium.com>
> > > > > Acked-by: Ralf Baechle <ralf@linux-mips.org>
> > > > 
> > > > 
> > > > > +   	 /* Put the saved pointer to vcpu (s1) back into the DDATA_LO Register */
> > > > 
> > > > git am detects a whitespace error here ("space before tab in indent").
> > > > It's got spaces before and after the tab actually.
> > > > 
> > > > >      /* load the guest context from VCPU and return */
> > > > 
> > > > this comment could have it's indentation fixed too
> > > > 
> > > > Otherwise, for all 3 patches:
> > > > 
> > > > Reviewed-by: James Hogan <james.hogan@imgtec.com>
> > > 
> > > I'm happy with the patch series as well and will fix this issue when
> > > applying the patch.
> > > 
> > kvm fixes usually go through kvm.git tree for all arches. Any special
> > reasons you want to get those through mips tree?
> 
> MIPS fixes usually go through the MIPS tree ;-)
> 
arch/*/kvm/ fixes usually go through the kvm.git though :) KVM arch
code, after it is reasonably stable, usually depends more on kvm common
code then arch code and kvm development suppose to happen against
kvm.git otherwise APIs can go out of sync. I need to get acks of MIPS
people before taking patches of course.

When patch series touches code outside of arch/*/kvm, like David says
the next one will, it make sense to merge it through MIPS tree, just
please take KVM maintainers ACK for kvm part.

> I don't care which tree this stuff goes through - but a general experience
> is that things that affect MIPS systems receive most testing if going
> through the MIPS tree.
> 
>   Ralf

--
			Gleb.
