Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab3FFKHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:07:50 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:47932 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754276Ab3FFKHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:07:48 -0400
Date: Thu, 6 Jun 2013 11:07:45 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 1/4] efi: Convert runtime services function ptrs
Message-ID: <20130606100745.GF30420@console-pimps.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-2-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370177770-26661-2-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Jun, at 02:56:07PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> ... to void * like the boot services and lose all the void * casts. No
> functionality change.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/boot/compressed/eboot.c |  2 +-
>  arch/x86/include/asm/efi.h       | 28 ++++++++++++++--------------
>  include/linux/efi.h              | 28 ++++++++++++++--------------
>  3 files changed, 29 insertions(+), 29 deletions(-)

Thanks! I've chucked this into my 'urgent' queue because it's a pretty
straight forward cleanup and there's no point in allowing it to bitrot
any further (the change to eboot.c is already stale).

-- 
Matt Fleming, Intel Open Source Technology Center
