Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756451Ab3KZL4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 06:56:38 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58851 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754690Ab3KZL4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 06:56:37 -0500
Date: Tue, 26 Nov 2013 12:56:30 +0100
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] EFI runtime mapping work for v3.14
Message-ID: <20131126115630.GA21146@pd.tnic>
References: <20131125162854.GK11521@console-pimps.org>
 <20131126112650.GD2410@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131126112650.GD2410@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 12:26:50PM +0100, Ingo Molnar wrote:
> Just a side note, for future reference, this title lacks a verb and is 
> thus not self-describing:
> 
>    x86/efi: Runtime services virtual mapping
> 
> It should probably have been something like:
> 
>    x86/efi: Implement and enable separate, stable virtual mapping for runtime services
> 
> ?

My bad: it should've been "Reimplement runtime services virtual mapping"
or sth like that.

> Chances are that it will be a popular bisection target ;-)

I *so* hope your clairvoyant skills fail you this time :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
