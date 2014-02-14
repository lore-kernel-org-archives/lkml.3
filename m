Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaBNJWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 04:22:32 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:58804 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751638AbaBNJW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 04:22:29 -0500
Date: Fri, 14 Feb 2014 09:22:23 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Lejun Zhu <lejun.zhu@intel.com>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] x86, efi: Fix 32-bit fallout
Message-ID: <20140214092223.GH20717@console-pimps.org>
References: <1392362664-26608-1-git-send-email-bp@alien8.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392362664-26608-1-git-send-email-bp@alien8.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Feb, at 08:24:24AM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> We do not enable the new efi memmap on 32-bit and thus we need to run
> runtime_code_page_mkexec() unconditionally there. Fix that.
> 
> Reported-and-tested-by: Lejun Zhu <lejun.zhu@intel.com>
> Cc: <stable@vger.kernel.org> # v3.14+
> Signed-off-by: Borislav Petkov <bp@suse.de>

Should this definitely be tagged for -stable? I'm not sure it makes
sense to backport your EFI memmap rototill, so this has only been broken
since v3.14-rc1.

-- 
Matt Fleming, Intel Open Source Technology Center
