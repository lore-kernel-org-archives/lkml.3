Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965344Ab3FTQ3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:29:31 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57093 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935384Ab3FTQ32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:29:28 -0400
Date: Thu, 20 Jun 2013 17:29:16 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130620162916.GA25727@srcf.ucam.org>
References: <20130619125243.GD11209@gmail.com>
 <20130619130225.GA28311@pd.tnic>
 <20130619130434.GB24957@gmail.com>
 <20130619160804.GB27832@srcf.ucam.org>
 <20130620091321.GB6811@gmail.com>
 <20130620091537.GA17159@srcf.ucam.org>
 <20130620092237.GA6943@gmail.com>
 <20130620093337.GI32694@pd.tnic>
 <20130620094446.GA17882@srcf.ucam.org>
 <1371740019.2372.3.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371740019.2372.3.camel@dabdike>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 07:53:39AM -0700, James Bottomley wrote:

> Can't we detect Macs from some of the UEFI strings at boot time and do
> the right thing with the boot switch (which can be overriden from the
> kernel command line if we get it wrong)?

Yes, and then our behaviour differs from Windows and so we'll have 
inevitably broken some other system.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
