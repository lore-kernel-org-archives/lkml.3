Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaBXWGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:06:54 -0500
Received: from www.linutronix.de ([62.245.132.108]:60888 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaBXWGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:06:53 -0500
Date: Mon, 24 Feb 2014 23:06:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Bjorn Helgaas <bhelgaas@google.com>
cc: Jingoo Han <jg1.han@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mohit Kumar <mohit.kumar@st.com>, pci <linux-pci@vger.kernel.org>
Subject: Re: [patch 07/26] pci: pcie-designware: Remove irq_desc abuse
In-Reply-To: <CAErSpo5WW4=aL_BqhnrG+J1Xq=FVtdu0BWkHUyeiOrbBhqmYwg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1402242306060.21251@ionos.tec.linutronix.de>
References: <21860356.103351393198399120.JavaMail.weblogic@epml01> <CAErSpo5WW4=aL_BqhnrG+J1Xq=FVtdu0BWkHUyeiOrbBhqmYwg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014, Bjorn Helgaas wrote:
> On Sun, Feb 23, 2014 at 4:33 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> > On Monday, February 24, 2014 6:40 AM, Thomas Gleixner wrote:
> >>
> >> There is no reason to care about irq_desc in that context, escpecially
> >> as irq_data for that interrupt is retrieved as well.
> >>
> >> Use the proper accessor for the msi descriptor
> >>
> >> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> >> Cc: Bjorn Helgaas <bhelgaas@google.com>
> >> Cc: Jingoo Han <jg1.han@samsung.com>
> >> Cc: Mohit Kumar <mohit.kumar@st.com>
> >> Cc: pci <linux-pci@vger.kernel.org>
> >
> > Acked-by: Jingoo Han <jg1.han@samsung.com>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> Thomas, I assume you'll merge this along with the rest of your series.
>  I don't have any pending changes in this area.

I can do, but it does not depend on anything else, so you can pick it
up as well. Either way is fine.

Thanks,

	tglx
