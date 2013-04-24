Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3DXNUP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 09:20:15 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36035 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab3DXNUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 09:20:13 -0400
Date: Wed, 24 Apr 2013 15:20:10 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt.fleming@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH] x86, efi: Fix a build warning
Message-ID: <20130424132010.GB31707@pd.tnic>
References: <1366798154-1380-1-git-send-email-bp@alien8.de>
 <20130424105610.GA15815@gmail.com>
 <5177BF67.2040308@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5177BF67.2040308@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 12:17:59PM +0100, Matt Fleming wrote:
> We could either change all fields in efi_system_table or the
> efi_call_phys* prototypes. x86-64 already casts to (void *) when
> calling efi_call0(), etc, though I'm not entirely sure why void * is
> needed.

Well, sizeof(void *) == sizeof(unsigned long) for both bitness so size
shouldn't be the reason.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
