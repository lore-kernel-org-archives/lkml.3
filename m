Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbaKRK0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:26:25 -0500
Received: from ozlabs.org ([103.22.144.67]:47781 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbaKRK0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:26:23 -0500
Message-ID: <1416306379.28359.0.camel@concordia>
Subject: Re: [PATCH] [powerpc] Fix Text randomization
From: Michael Ellerman <mpe@ellerman.id.au>
To: Vineeth Vijayan <vvijayan@mvista.com>
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>
Date: Tue, 18 Nov 2014 21:26:19 +1100
In-Reply-To: <CAOpNGcuL-0SDSwDbExLWqWxwp=0zRtRnx_MUnNEb9ywSFrhh8A@mail.gmail.com>
References: <1415956325-10124-1-git-send-email-vvijayan@mvista.com>
	 <1416207214.2826.3.camel@concordia>
	 <CAOpNGcuL-0SDSwDbExLWqWxwp=0zRtRnx_MUnNEb9ywSFrhh8A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-18 at 12:50 +0530, Vineeth Vijayan wrote:
> On Mon, Nov 17, 2014 at 12:23 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> > On Fri, 2014-11-14 at 14:42 +0530, Vineeth Vijayan wrote:
> >> Now there is no way to disable TEXT randomization on a PPC32/PPC64
> >> machine. Text randomization happens even in the case of "echo 0 >
> >> /proc/sys/kernel/randomize_va_space"
> >>
> >> This happens due to the incorrect definition of ELF_ET_DYN_BASE
> >> at arch/powerpc/include/asm/elf.h
> >>
> >> The function randomize_et_dyn is redundant and is removed.
> >
> > The patch looks OK, but for the change log I was thinking something more like
> > this:
> >
> >
> > powerpc: Use generic PIE randomization
> >
> Ok. Thats better.
> Do you want me to send a new patch with updated change log as mentioned ?
 
No that's OK, I've already merged it.

cheers


