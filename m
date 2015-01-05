Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbbAEOP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:15:26 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:52424 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbbAEOPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:15:24 -0500
Date: Mon, 5 Jan 2015 14:15:21 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        matthew.garrett@nebula.com, jk@ozlabs.org, matt.fleming@intel.com,
        pjones@redhat.com
Subject: Re: [RFC] fs: make efivarfs a pseudo filesystem, built by default
 with EFI
Message-ID: <20150105141521.GC3163@console-pimps.org>
References: <1418925049-3659-1-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418925049-3659-1-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec, at 05:50:49PM, Leif Lindholm wrote:
> efivars is currently enabled under MISC_FILESYSTEMS, which is decribed
> as "such as filesystems that came from other operating systems".
> In reality, it is a pseudo filesystem, providing access to the kernel
> UEFI variable interface.
> 
> Since this is the preferred interface for accessing UEFI variables, over
> the legacy efivars interface, also build it by default as a module if
> CONFIG_EFI.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  fs/Kconfig          | 2 +-
>  fs/efivarfs/Kconfig | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)

Looks good to me Leif.

Unless I hear otherwise, I'll apply this to the 'next' branch of the EFI
tree this week.

-- 
Matt Fleming, Intel Open Source Technology Center
