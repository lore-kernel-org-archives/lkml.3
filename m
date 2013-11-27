Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab3K0PHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:07:20 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52245 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab3K0PHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:07:17 -0500
Date: Wed, 27 Nov 2013 16:07:10 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org,
        mjg59@srcf.ucam.org, hpa@zytor.com,
        James.Bottomley@HansenPartnership.com, vgoyal@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au, kexec@lists.infradead.org,
        greg@kroah.com, matt@console-pimps.org, toshi.kani@hp.com
Subject: Re: [PATCH v4 11/12] x86: reserve setup_data ranges late after
 parsing memmap cmdline
Message-ID: <20131127150710.GH32267@pd.tnic>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-12-git-send-email-dyoung@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1385445477-9665-12-git-send-email-dyoung@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 01:57:56PM +0800, Dave Young wrote:
> Kdump kernel using memmap=exactmap, move e820_reserve_setup_data after
> parsing early params so they can be set reserved finally. Or kdump kernel
> will warn about ioremap a normal ram range.

I had to stare for a while at this commit message, rereading it a couple
of times and looking at the code in order to understand why you're
moving the call further down.

Please rewrite it into something more readable.

The usual structure which you could use is:

1. Currently we have A
2. We need B
3. In order to achieve it, we do C

or something to that effect.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
