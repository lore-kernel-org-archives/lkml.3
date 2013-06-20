Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161151Ab3FTQqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:46:18 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55000 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161046Ab3FTQqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:46:16 -0400
Message-ID: <1371746775.2372.11.camel@dabdike>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Date: Thu, 20 Jun 2013 09:46:15 -0700
In-Reply-To: <20130620162916.GA25727@srcf.ucam.org>
References: <20130619125243.GD11209@gmail.com>
	 <20130619130225.GA28311@pd.tnic> <20130619130434.GB24957@gmail.com>
	 <20130619160804.GB27832@srcf.ucam.org> <20130620091321.GB6811@gmail.com>
	 <20130620091537.GA17159@srcf.ucam.org> <20130620092237.GA6943@gmail.com>
	 <20130620093337.GI32694@pd.tnic> <20130620094446.GA17882@srcf.ucam.org>
	 <1371740019.2372.3.camel@dabdike> <20130620162916.GA25727@srcf.ucam.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-20 at 17:29 +0100, Matthew Garrett wrote:
> On Thu, Jun 20, 2013 at 07:53:39AM -0700, James Bottomley wrote:
> 
> > Can't we detect Macs from some of the UEFI strings at boot time and do
> > the right thing with the boot switch (which can be overriden from the
> > kernel command line if we get it wrong)?
> 
> Yes, and then our behaviour differs from Windows and so we'll have 
> inevitably broken some other system.

Unless you can think of the way out of this, we seem to have the stark
choice of behave like windows or allow kexec.  For the server market,
kexec wins, so either we find a way not to have to make the choice or we
do something automatic to make it fairly painless.

James




