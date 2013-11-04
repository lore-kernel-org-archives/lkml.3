Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab3KDJVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 04:21:35 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:47087 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752607Ab3KDJVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 04:21:32 -0500
Date: Mon, 4 Nov 2013 09:21:27 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH 00/11] EFI runtime services virtual mapping, vN++
Message-ID: <20131104092127.GC21688@console-pimps.org>
References: <1383236709-19716-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383236709-19716-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Oct, at 05:24:58PM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Hi all,
> 
> here's maybe the final version of the patchset, no major changes since
> the last time but cosmetic and cleanups and tidying as requested by Matt
> and others.
> 
> Patches also at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git#efi

Thanks Borislav, I've merged this version in the EFI 'next' branch to
queue up for v3.14.

Good work!

-- 
Matt Fleming, Intel Open Source Technology Center
