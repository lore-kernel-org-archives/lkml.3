Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaEWVfE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:35:04 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:60134 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbaEWVfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:35:02 -0400
Message-ID: <1400880900.31526.55.camel@x220>
Subject: Re: powerpc: remove checks for CONFIG_BOOK3E_MMU_TLB_STATS
From: Paul Bolle <pebolle@tiscali.nl>
To: Scott Wood <scottwood@freescale.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Date: Fri, 23 May 2014 23:35:00 +0200
In-Reply-To: <1400865146.12823.54.camel@snotra.buserror.net>
References: <1400608550.4912.48.camel@x220>
	 <20140522223758.GA20343@home.buserror.net> <1400830406.31526.6.camel@x220>
	 <1400839597.31526.21.camel@x220>
	 <1400865146.12823.54.camel@snotra.buserror.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 May 2014 21:35:00.0969 (UTC) FILETIME=[D9FE3590:01CF76CE]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-05-23 at 12:12 -0500, Scott Wood wrote:
> On Fri, 2014-05-23 at 12:06 +0200, Paul Bolle wrote: 
> > For what it's worth: I can't reproduce this error with the cross
> > compiler now shipped with Fedora 20 (ie, powerpc64-linux-gnu-gcc (GCC)
> > 4.8.1 20130717 (Red Hat 4.8.1-5)). It shows a nice and clean
> >      AS      arch/powerpc/mm/tlb_low_64e.o
> > 
> > in the output.
> > 
> > That's v3.15-rc6, with just this patch, and using a .config generated,
> > with "make oldconfig", from arch/powerpc/configs/ppc64e_defconfig.
> 
> Hmm, I tried applying again and it was fine.

That's a relieve. Thanks, again, for testing!


Paul Bolle

