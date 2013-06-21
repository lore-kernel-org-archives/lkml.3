Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422921Ab3FUOVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 10:21:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53048 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161356Ab3FUOVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:21:12 -0400
Date: Fri, 21 Jun 2013 16:21:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ingo Molnar <mingo@kernel.org>, Linux EFI <linux-efi@vger.kernel.org>,
        Matt Fleming <matt@console-pimps.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH -v2 0/4] EFI 1:1 mapping
Message-ID: <20130621142101.GG22006@pd.tnic>
References: <20130620170124.GA19877@pd.tnic>
 <20130620171210.GA26593@srcf.ucam.org>
 <20130620180808.GB19877@pd.tnic>
 <20130620181015.GA27833@srcf.ucam.org>
 <20130620181445.GA791@pd.tnic>
 <20130620181731.GA27960@srcf.ucam.org>
 <20130620184736.GC19877@pd.tnic>
 <51C383AC.4060706@zytor.com>
 <20130621072356.GA22006@pd.tnic>
 <ca8f8134-24d9-4f96-8876-e24892efc849@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ca8f8134-24d9-4f96-8876-e24892efc849@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 03:05:30AM -0700, H. Peter Anvin wrote:
> If you cap it you are basically imposing a constraint on the firmware
> and may not run properly (or at least have to turn off EFI runtime
> calls with all that implies.)

I don't want to cap EFI just for the fun of it but rather set a limit
so that the next one who wants a chunk of the virtual address space can
have a reliable limit from where she/he can start. Otherwise we won't
know where EFI reliably ends...

> It might be good to have a sanity check but it needs to be pretty
> generous.

64 Gb generous enough?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
