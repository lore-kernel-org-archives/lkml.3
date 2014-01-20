Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469AbaATNqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:46:39 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36680 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbaATNqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:46:38 -0500
Date: Mon, 20 Jan 2014 14:46:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>
Subject: Re: [PATCH 5/5] efi: Split efi_enter_virtual_mode
Message-ID: <20140120134625.GD3003@pd.tnic>
References: <1390045698-16882-1-git-send-email-bp@alien8.de>
 <1390045698-16882-6-git-send-email-bp@alien8.de>
 <20140120134407.GB684@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140120134407.GB684@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 01:44:07PM +0000, Matt Fleming wrote:
> > +void __init kexec_enter_virtual_mode(void)
> > +{
> 
> Could this be static for now?

Didn't you wanna do arch/x86/platform/efi/kexec.c anyway?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
