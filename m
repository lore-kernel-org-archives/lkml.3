Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab3G1Eja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 00:39:30 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:64903 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3G1Ej3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 00:39:29 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: DT bindings as ABI [was: Do we have people interested in device tree janitoring / cleanup?]
To: Olof Johansson <olof@lixom.net>, Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Domenico Andreoli <cavokz@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
Date: Sat, 27 Jul 2013 22:39:25 -0600
Message-Id: <20130728043925.8F3BE3E08FE@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jul 2013 09:09:19 -0700, Olof Johansson <olof@lixom.net> wrote:
> [I'm adding LKML and ksummit-discuss to this thread, since the ACPI/DT
> discussions have been covered there and this overlaps some with that]
> 
> On Thu, Jul 25, 2013 at 7:38 AM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > On Thu, Jul 25, 2013 at 03:27:02PM +0100, Russell King - ARM Linux wrote:
> >> Remember the stated assertion when DT was first added to the kernel: the
> >> DT descriptions _will_ become a separately maintained project which is
> >> independent of the kernel.  They will _not_ be kernel version specific.
> >
> > I'm looking forward to this.
> >
> > Question for the DT guys: what are the plans here? Are we going to get
> > rid of the .dts files inside the kernel tree?
> 
> In the discussions we had in Dublin, a couple of options on how to
> lock in bindings were discussed. I'm a little surprised that Grant
> didn't cover them in his initial emails on the new maintainership
> model, but maybe he wanted the new group to handle it. And they didn't
> bring it up yet either. So I am. :-)

Excellent! My plan to avoid responsibility for stuff is proceeding.
Actually, I think I touched on it, but the details got lost in my head
among all the other stuff we discussed two weeks ago. Thanks for getting
this detail down into an email.

g.

