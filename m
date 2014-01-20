Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbaATOsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 09:48:21 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:43514 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750807AbaATOsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:48:19 -0500
Date: Mon, 20 Jan 2014 14:48:16 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 5/5] efi: Split efi_enter_virtual_mode
Message-ID: <20140120144816.GC684@console-pimps.org>
References: <1390045698-16882-1-git-send-email-bp@alien8.de>
 <1390045698-16882-6-git-send-email-bp@alien8.de>
 <20140120134407.GB684@console-pimps.org>
 <20140120134625.GD3003@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120134625.GD3003@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jan, at 02:46:25PM, Borislav Petkov wrote:
> On Mon, Jan 20, 2014 at 01:44:07PM +0000, Matt Fleming wrote:
> > > +void __init kexec_enter_virtual_mode(void)
> > > +{
> > 
> > Could this be static for now?
> 
> Didn't you wanna do arch/x86/platform/efi/kexec.c anyway?

Yes, but the patches are easier to review if we make
kexec_enter_virtual_mode() global when moving it into a new file.

Plus it makes this patch that little bit smaller because the
modification to efi.h is unnecessary.

-- 
Matt Fleming, Intel Open Source Technology Center
