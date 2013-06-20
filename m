Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161179Ab3FTRBg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 13:01:36 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36398 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758006Ab3FTRBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 13:01:33 -0400
Date: Thu, 20 Jun 2013 19:01:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ingo Molnar <mingo@kernel.org>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130620170124.GA19877@pd.tnic>
References: <20130619160804.GB27832@srcf.ucam.org>
 <20130620091321.GB6811@gmail.com>
 <20130620091537.GA17159@srcf.ucam.org>
 <20130620092237.GA6943@gmail.com>
 <20130620093337.GI32694@pd.tnic>
 <20130620094446.GA17882@srcf.ucam.org>
 <1371740019.2372.3.camel@dabdike>
 <20130620162916.GA25727@srcf.ucam.org>
 <1371746775.2372.11.camel@dabdike>
 <20130620165426.GB26214@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130620165426.GB26214@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 05:54:26PM +0100, Matthew Garrett wrote:
> On Thu, Jun 20, 2013 at 09:46:15AM -0700, James Bottomley wrote:
> 
> > Unless you can think of the way out of this, we seem to have the stark
> > choice of behave like windows or allow kexec.  For the server market,
> > kexec wins, so either we find a way not to have to make the choice or we
> > do something automatic to make it fairly painless.
> 
> hpa suggested ensuring that UEFI regions are mapped at fixed high 
> offsets. Someone who cares about kexec should probably make that happen.

If we can detect the Macs, we can make this decision automatic. And
since no Mac boots windoze, a single DMI check of the sort "if (Mac)"
should suffice.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
