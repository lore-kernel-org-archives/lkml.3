Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbaEWKHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:07:45 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:62566 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752069AbaEWKGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:06:39 -0400
Message-ID: <1400839597.31526.21.camel@x220>
Subject: Re: powerpc: remove checks for CONFIG_BOOK3E_MMU_TLB_STATS
From: Paul Bolle <pebolle@tiscali.nl>
To: Scott Wood <scottwood@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Fri, 23 May 2014 12:06:37 +0200
In-Reply-To: <1400830406.31526.6.camel@x220>
References: <1400608550.4912.48.camel@x220>
	 <20140522223758.GA20343@home.buserror.net> <1400830406.31526.6.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 May 2014 10:06:37.0506 (UTC) FILETIME=[AF35EA20:01CF766E]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-23 at 09:33 +0200, Paul Bolle wrote:
> Scott,
> 
> On Thu, 2014-05-22 at 17:37 -0500, Scott Wood wrote:
> > /home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S: Assembler messages:
> > /home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:89: Error: unrecognized opcode: `tlb_miss_prolog_stats'
> > /home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:238: Error: unrecognized opcode: `tlb_miss_prolog_stats'
> > /home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:269: Error: unrecognized opcode: `tlb_miss_prolog_stats'
> > /home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:281: Error: unrecognized opcode: `tlb_miss_prolog_stats'
> > /home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:441: Error: unrecognized opcode: `tlb_miss_prolog_stats'
> > /home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:510: Error: unrecognized opcode: `tlb_miss_prolog_stats'
> > /home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:881: Error: unrecognized opcode: `tlb_miss_prolog_stats'
> > /home/scott/fsl/git/linux/upstream/arch/powerpc/mm/tlb_low_64e.S:918: Error: unrecognized opcode: `tlb_miss_prolog_stats'
> 
> Thanks for testing!
> 
> That's a bit surprising. The patch is intended to be a non event. Ie, it
> only removes what the preprocessor would have removed anyway. Unless I
> botched it, of course.
> 
> What exactly did you test there?

For what it's worth: I can't reproduce this error with the cross
compiler now shipped with Fedora 20 (ie, powerpc64-linux-gnu-gcc (GCC)
4.8.1 20130717 (Red Hat 4.8.1-5)). It shows a nice and clean
     AS      arch/powerpc/mm/tlb_low_64e.o

in the output.

That's v3.15-rc6, with just this patch, and using a .config generated,
with "make oldconfig", from arch/powerpc/configs/ppc64e_defconfig.


Paul Bolle

