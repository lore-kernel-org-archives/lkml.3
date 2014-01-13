Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbaAMRAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:00:35 -0500
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:20288 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbaAMRAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:00:31 -0500
Message-ID: <1389632070.1792.184.camel@misato.fc.hp.com>
Subject: Re: [PATCH 0/4] EFI memmap fix v2
From: Toshi Kani <toshi.kani@hp.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>
Date: Mon, 13 Jan 2014 09:54:30 -0700
In-Reply-To: <1389630165.1792.180.camel@misato.fc.hp.com>
References: <1389473370-1940-1-git-send-email-bp@alien8.de>
	 <1389630165.1792.180.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-13 at 09:22 -0700, Toshi Kani wrote:
> On Sat, 2014-01-11 at 21:49 +0100, Borislav Petkov wrote:
> > From: Borislav Petkov <bp@suse.de>
> > 
> > Ok, here's v2 rebased and rediffed against tip (which has the relevant
> > efi branches).
> > 
> > Toshi, I'm pushing it to:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git#efi-fixes
> > 
> > so that you can give it another run and so that the build robot can poke
> > at it.
> 
> I tested the 4 patches on top of Matt's efi tree under kexec branch.
> Unfortunately, it hit the same panic again...  I will send you the full
> dmesg with EFI_PGT_DBG enabled in a separate email.  I will also test
> your git tree as well. 

The git tree kernel also hit the same panic.  Will send you the dmesg
output in a separate email as well.

Thanks,
-Toshi


