Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504Ab3FCVTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 17:19:13 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45018 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756973Ab3FCVTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 17:19:09 -0400
Message-ID: <1370294345.9888.12.camel@dabdike>
Subject: Re: [PATCH 0/4] EFI 1:1 mapping
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Borislav Petkov <bp@alien8.de>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Date: Mon, 03 Jun 2013 14:19:05 -0700
In-Reply-To: <20130603181110.GA25060@srcf.ucam.org>
References: <20130603081148.GB13607@nazgul.tnic>
	 <1370269642.2910.4.camel@dabdike> <20130603143010.GA20252@srcf.ucam.org>
	 <1370270282.2910.9.camel@dabdike> <20130603152122.GA21312@srcf.ucam.org>
	 <1370276286.2910.29.camel@dabdike> <20130603162435.GA22563@srcf.ucam.org>
	 <1370277307.2910.39.camel@dabdike> <20130603164237.GA23146@srcf.ucam.org>
	 <1370282703.9888.5.camel@dabdike> <20130603181110.GA25060@srcf.ucam.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 19:11 +0100, Matthew Garrett wrote:
> > > The problem there is that you're saying "In theory". We know that 
> > > Windows doesn't behave this way, so we have no legitimate expectation 
> > > that it'll work. We know that it doesn't on some Apple hardware.
> > 
> > Fine, you say we need to call SetVirtualAddressMap because windows does,
> > I agree, I'm just saying we get additional safety from calling it with
> > the 1:1 map ... I don't see what the problem is.
> 
> No. I'm saying that calling it with the 1:1 map is something very 
> different to the behaviour of Windows, and I'm saying that doing so is 
> known to cause variable writes on some Apple hardware to stop working. 
> If we're aiming for maximum compatibility, we need to call 
> SetVirtualAddressMap() with addresses above the canonicalisation hole.

OK, so tell me this problem: it's a new one one me.  I think you're
saying if we don't call SetVirtualAddressMap with a mapping above a
certain value, some Apple system breaks somehow? (how?).

James



