Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaANLz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:55:57 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56074 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbaANLzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:55:52 -0500
Date: Tue, 14 Jan 2014 12:55:47 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: AMD errata 793 (CVE-2013-6885) needs a workaround in Linux?
Message-ID: <20140114115547.GA29887@pd.tnic>
References: <20140114114133.GA31473@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140114114133.GA31473@khazad-dum.debian.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 09:41:33AM -0200, Henrique de Moraes Holschuh wrote:
> I just got this assigned to amd64-microcode in Debian, but it is something
> that needs to be worked around by the EFI/BIOS and/or the kernel.
> 
> Since we all know just how well it pans out to depend on BIOS/EFI updates
> for *anything*, I'm raising the issue here.  IMHO looks like it would be
> worthwhile to either set the relevant MSR in the kernel if the BIOS didn't
> do it, or at least warn the user of the need for a BIOS/EFI update...
> 
> It is the usual hangs-core type of CPU errata (therefore, the best type
> since it won't cause silent data corruption).  gcc-produced code managed to
> trigger it (in DragonFly BSD).

I think this is a different issue than the dragonfly issue. In any case,
if AMD delivers all BIOS with this workaround enabled, we don't need to
do anything. And I asked them about it so we'll have an answer soon, I
hope.

In any case, I'm on it.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
