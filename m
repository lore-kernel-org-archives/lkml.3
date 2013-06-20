Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161135Ab3FTQp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:45:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161046Ab3FTQp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:45:58 -0400
Date: Thu, 20 Jun 2013 18:44:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
In-Reply-To: <20130620162916.GA25727@srcf.ucam.org>
Message-ID: <alpine.LRH.2.00.1306201843430.3478@twin.jikos.cz>
References: <20130619125243.GD11209@gmail.com> <20130619130225.GA28311@pd.tnic> <20130619130434.GB24957@gmail.com> <20130619160804.GB27832@srcf.ucam.org> <20130620091321.GB6811@gmail.com> <20130620091537.GA17159@srcf.ucam.org> <20130620092237.GA6943@gmail.com>
 <20130620093337.GI32694@pd.tnic> <20130620094446.GA17882@srcf.ucam.org> <1371740019.2372.3.camel@dabdike> <20130620162916.GA25727@srcf.ucam.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013, Matthew Garrett wrote:

> > Can't we detect Macs from some of the UEFI strings at boot time and do
> > the right thing with the boot switch (which can be overriden from the
> > kernel command line if we get it wrong)?
> 
> Yes, and then our behaviour differs from Windows

How so? Windows don't work on those older Macs as well, do they?

So if we properly detect those (and only those), we mimic Windows 
completely, right?

-- 
Jiri Kosina
SUSE Labs

