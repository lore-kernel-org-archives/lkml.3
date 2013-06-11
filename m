Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab3FKJdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 05:33:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47080 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab3FKJdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 05:33:20 -0400
Date: Tue, 11 Jun 2013 11:33:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: Linux EFI <linux-efi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 1/4] efi: Convert runtime services function ptrs
Message-ID: <20130611093314.GA15624@pd.tnic>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-2-git-send-email-bp@alien8.de>
 <20130606100745.GF30420@console-pimps.org>
 <20130611064912.GG31198@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130611064912.GG31198@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 07:49:12AM +0100, Matt Fleming wrote:
> OK, I chickened out of sending this in my latest pull request
> after reading Linus' -rc5 email about him not wanting to see any
> non-critical changes. I've stuck it in the 'next' branch with the rest
> of the stuff for v3.11.

Yep, did the same with a couple of edac patches too - cleanups can wait.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
