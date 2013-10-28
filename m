Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab3J1LKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 07:10:31 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43676 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab3J1LK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 07:10:29 -0400
Date: Mon, 28 Oct 2013 12:10:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: Matt Fleming <matt@console-pimps.org>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-efi@vger.kernel.org, fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 11/12] efi: Add an efi= kernel command line parameter
Message-ID: <20131028111026.GG4314@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
 <20131008164701.GC16793@pd.tnic>
 <20131028110213.GJ1982@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131028110213.GJ1982@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 11:02:13AM +0000, Matt Fleming wrote:
> This patch should be part of PATCH 12.

I wanted it to be separate as it adds an unrelated functionality but I
don't really care all that much - I'll merge it.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
