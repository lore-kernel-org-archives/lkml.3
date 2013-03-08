Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab3CHUOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:14:18 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:40668 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216Ab3CHUOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:14:14 -0500
Date: Fri, 8 Mar 2013 15:13:31 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v2 10/26] x86, irq: Convert irq_2_pin list to generic list
Message-ID: <20130308201331.GA21755@phenom.dumpdata.com>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
 <1360351703-20571-11-git-send-email-yinghai@kernel.org>
 <20130308195055.GD6622@phenom.dumpdata.com>
 <CAE9FiQXZAdndUMEH-yBOvvx2jSMC3tQqs73LmdaY_ni+W=nFHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQXZAdndUMEH-yBOvvx2jSMC3tQqs73LmdaY_ni+W=nFHw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 12:00:43PM -0800, Yinghai Lu wrote:
> On Fri, Mar 8, 2013 at 11:50 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > On Fri, Feb 08, 2013 at 11:28:07AM -0800, Yinghai Lu wrote:
> >> Now irq_2_pin list is own grown list.
> >
> > I think you meant to say 'has its own list'. Not sure how
> > its growing?
> >
> >> We can use generic list to replace it so we could generic helper
> >> functions to operate it.
> >
> > You need to put the verb a bit earlier. Perhaps:
> >
> > ".. generic list to replace so that we can operate using
> > generic helper functions."
> 
> missed use before generic helper.

That would work as well.

> 
> >
> >>
> >> Also make free_irq_cfg() free irq_2_pin list to support coming ioapic
> >> hotplug.
> >
> > If you have them ready - could you say the titles of the patches here?
> 
> list them all ?

No that would not work. Perhaps the first one that introduces the code
that uses irq_2_pin ?
