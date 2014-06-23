Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbaFWVUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:20:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754424AbaFWVUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:20:36 -0400
Message-ID: <1403558424.755.58.camel@deneb.redhat.com>
Subject: Re: [PATCH 2/3] efi/reboot: Allow powering off machines using EFI
From: Mark Salter <msalter@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        Aubrey Li <aubrey.li@linux.intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Date: Mon, 23 Jun 2014 17:20:24 -0400
In-Reply-To: <1403185225-9031-3-git-send-email-matt@console-pimps.org>
References: <1403185225-9031-1-git-send-email-matt@console-pimps.org>
	 <1403185225-9031-3-git-send-email-matt@console-pimps.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-19 at 14:40 +0100, Matt Fleming wrote:
> From: Matt Fleming <matt.fleming@intel.com>
> 
> Not only can EfiResetSystem() be used to reboot, it can also be used to
> power down machines.
> 
> By and large, this functionality doesn't work very well across the range
> of EFI machines in the wild, so it should definitely only be used as a
> last resort. In an ideal world, this wouldn't be needed at all.
> 
> Unfortunately, we're starting to see machines where EFI is the *only*
> reliable way to power down, and nothing else, not PCI, not ACPI, works.
> 
> efi_poweroff_required() should be implemented on a per-architecture
> basis, since exactly when we should be using EFI runtime services is a
> platform-specific decision. There's no analogue for reboot because each
> architecture handles reboot very differently - the x86 code in
> particular is pretty complex.
> 
> Patches to enable this for specific classes of hardware will be
> submitted separately.
> 
> Cc: Mark Salter <msalter@redhat.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---

Tested-by: Mark Salter <msalter@redhat.com>


