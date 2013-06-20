Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161170Ab3FTQxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:53:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:57359 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161156Ab3FTQxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:53:18 -0400
Date: Thu, 20 Jun 2013 17:53:11 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130620165311.GA26214@srcf.ucam.org>
References: <20130619130434.GB24957@gmail.com>
 <20130619160804.GB27832@srcf.ucam.org>
 <20130620091321.GB6811@gmail.com>
 <20130620091537.GA17159@srcf.ucam.org>
 <20130620092237.GA6943@gmail.com>
 <20130620093337.GI32694@pd.tnic>
 <20130620094446.GA17882@srcf.ucam.org>
 <1371740019.2372.3.camel@dabdike>
 <20130620162916.GA25727@srcf.ucam.org>
 <alpine.LRH.2.00.1306201843430.3478@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1306201843430.3478@twin.jikos.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 06:44:46PM +0200, Jiri Kosina wrote:

> So if we properly detect those (and only those), we mimic Windows 
> completely, right?

No. Windows passes addresses above the phys/virt split to 
SetVirtualAddressMap().

-- 
Matthew Garrett | mjg59@srcf.ucam.org
