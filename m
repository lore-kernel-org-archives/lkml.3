Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab3J1LCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 07:02:21 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:51469 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755993Ab3J1LCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 07:02:18 -0400
Date: Mon, 28 Oct 2013 11:02:13 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-efi@vger.kernel.org, fwts-devel@lists.ubuntu.com
Subject: Re: [PATCH 11/12] efi: Add an efi= kernel command line parameter
Message-ID: <20131028110213.GJ1982@console-pimps.org>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20131008164551.GB16793@pd.tnic>
 <20131008164701.GC16793@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131008164701.GC16793@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Oct, at 06:47:02PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> ... for passing miscellaneous options and chicken bits from the command
> line.
> 
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  arch/x86/platform/efi/efi.c | 9 +++++++++
>  1 file changed, 9 insertions(+)

This patch should be part of PATCH 12.

-- 
Matt Fleming, Intel Open Source Technology Center
