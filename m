Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139Ab3FSQFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:05:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:38331 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab3FSQFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:05:37 -0400
Date: Wed, 19 Jun 2013 17:05:23 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130619160523.GA27832@srcf.ucam.org>
References: <1371491416-11037-1-git-send-email-bp@alien8.de>
 <20130619125243.GD11209@gmail.com>
 <20130619130225.GA28311@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619130225.GA28311@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 03:02:25PM +0200, Borislav Petkov wrote:
> On Wed, Jun 19, 2013 at 02:52:43PM +0200, Ingo Molnar wrote:
> > I hope making it a weird boot option is not the end plan, there's
> > little point in _not_ enabling 1:1 mappings by default eventually:
> > the 1:1 mapping is supposed to emulate a "Windows compatible" EFI
> > environment better and is expected to work around certain EFI runtime
> > crashes.
> 
> And yet there are the Macs which reportedly cannot stomach this.

I suspect they'll be fine with having a 1:1 map, as long as we pass the 
high mappings via SetVirtualAddressMap().

-- 
Matthew Garrett | mjg59@srcf.ucam.org
