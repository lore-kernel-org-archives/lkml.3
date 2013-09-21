Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3IUQD5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 12:03:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52398 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979Ab3IUQDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 12:03:55 -0400
Date: Sat, 21 Sep 2013 18:03:47 +0200
From: Borislav Petkov <bp@alien8.de>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Matt Fleming <matt@console-pimps.org>, Mark Salter <msalter@redhat.com>,
        X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Vivek Goyal <vgoyal@redhat.com>, Dave Young <dyoung@redhat.com>,
        linux-efi@vger.kernel.org, Roy Franz <roy.franz@linaro.org>
Subject: Re: [PATCH 02/11] efi: Remove EFI_PAGE_SHIFT and EFI_PAGE_SIZE
Message-ID: <20130921160347.GE1587@pd.tnic>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <1379602494-26684-3-git-send-email-bp@alien8.de>
 <20130920104249.GA21381@console-pimps.org>
 <20130921152139.GG2737@rocoto.smurfnet.nu>
 <20130921154143.GC1587@pd.tnic>
 <20130921155039.GD1587@pd.tnic>
 <20130921160121.GI2737@rocoto.smurfnet.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130921160121.GI2737@rocoto.smurfnet.nu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 21, 2013 at 06:01:21PM +0200, Leif Lindholm wrote:
> Correct. On arm64, EFI_PAGE_SIZE will be 4K, and PAGE_SIZE can be 4K
> or 64K, with at least Fedora opting for 64K.

Hm, ok, it looks like we want to keep EFI_PAGE_SIZE.

Oh well.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
