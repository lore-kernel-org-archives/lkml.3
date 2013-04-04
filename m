Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506Ab3DDLle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 07:41:34 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:4677 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758862Ab3DDLld convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 07:41:33 -0400
From: Oskar Andero <oskar.andero@sonymobile.com>
Date: Thu, 4 Apr 2013 13:41:29 +0200
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "anil.s.keshavamurthy@intel.com" <anil.s.keshavamurthy@intel.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "Lekanovic, Radovan" <Radovan.Lekanovic@sonymobile.com>,
        =?iso-8859-1?Q?Davidsson=2C_Bj=F6rn?= 
	<Bjorn.Davidsson@sonymobile.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 0/4] kprobes: split blacklist into common and arch
Message-ID: <20130404114129.GC2481@caracas.corpusers.net>
References: <1364977734-32267-1-git-send-email-oskar.andero@sonymobile.com>
 <515D64C6.9050903@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <515D64C6.9050903@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13:32 Thu 04 Apr     , Vineet Gupta wrote:
> Hi Oskar,
> 
> On 04/03/2013 01:58 PM, oskar.andero@sonymobile.com wrote:
> > Hi,
> > 
> > This is a slight rework of the following patches which I posted earlier:
> > [PATCH] Kprobes blacklist: Conditionally add x86-specific symbols
> > [PATCH] delay blacklist symbol lookup until we actually need it
> > 
> > This serie includes a patch that moves the architecture dependent black points
> > to the arch/ directory and the x86 patch was modified to follow that patch.
> > 
> > -Oskar
> > 
> > Björn Davidsson (1):
> >   kprobes: move x86-specific blacklist symbols to arch directory
> > 
> > Oskar Andero (2):
> >   kprobes: split blacklist into common and arch
> >   kprobes: replace printk with pr_-functions
> > 
> > Toby Collett (1):
> >   kprobes: delay blacklist symbol lookup until we actually need it
> > 
> >  arch/arc/kernel/kprobes.c      |   3 +
> >  arch/arm/kernel/kprobes.c      |   2 +
> >  arch/avr32/kernel/kprobes.c    |   3 +
> >  arch/ia64/kernel/kprobes.c     |   3 +
> >  arch/mips/kernel/kprobes.c     |   3 +
> >  arch/mn10300/kernel/kprobes.c  |   2 +
> >  arch/powerpc/kernel/kprobes.c  |   3 +
> >  arch/s390/kernel/kprobes.c     |   3 +
> >  arch/sh/kernel/kprobes.c       |   3 +
> >  arch/sparc/kernel/kprobes.c    |   3 +
> >  arch/x86/kernel/kprobes/core.c |   7 ++
> >  kernel/kprobes.c               | 149 ++++++++++++++++++++++++++---------------
> >  12 files changed, 130 insertions(+), 54 deletions(-)
> > 
> 
> For any arch changes, however trivial they might be, you need to CC the respective
> maintainers, or atleast post the patches on linux-arch so we know what's going on !

Thanks Vineet! I will make sure to add linux-arch on CC for version 2.

-Oskar
