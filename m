Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965419Ab3FTOfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 10:35:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965258Ab3FTOfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 10:35:07 -0400
Date: Thu, 20 Jun 2013 16:33:50 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
In-Reply-To: <20130620094446.GA17882@srcf.ucam.org>
Message-ID: <alpine.LRH.2.00.1306201632490.3478@twin.jikos.cz>
References: <1371491416-11037-1-git-send-email-bp@alien8.de> <20130619125243.GD11209@gmail.com> <20130619130225.GA28311@pd.tnic> <20130619130434.GB24957@gmail.com> <20130619160804.GB27832@srcf.ucam.org> <20130620091321.GB6811@gmail.com> <20130620091537.GA17159@srcf.ucam.org>
 <20130620092237.GA6943@gmail.com> <20130620093337.GI32694@pd.tnic> <20130620094446.GA17882@srcf.ucam.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013, Matthew Garrett wrote:

> > This will break the Macs so maybe we can do
> > 
> > efi=no_11_map
> > 
> > so the Macs can still boot but use the 1:1 map by default.
> 
> I'm going to guess that there are more people running unmodified Linux 
> kernels on Macs than there are people using kexec, 

I'd be careful in order not to underestimate how much kexec is being used. 
[At least some] distros are using it during installation process.

-- 
Jiri Kosina
SUSE Labs

