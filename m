Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbaFWVTD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:19:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbaFWVTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:19:00 -0400
Message-ID: <1403558325.755.56.camel@deneb.redhat.com>
Subject: Re: [PATCH 1/3] efi/reboot: Add generic wrapper around
 EfiResetSystem()
From: Mark Salter <msalter@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        Aubrey Li <aubrey.li@linux.intel.com>,
        Matt Fleming <matt.fleming@intel.com>, Tony Luck <tony.luck@intel.com>
Date: Mon, 23 Jun 2014 17:18:45 -0400
In-Reply-To: <1403185225-9031-2-git-send-email-matt@console-pimps.org>
References: <1403185225-9031-1-git-send-email-matt@console-pimps.org>
	 <1403185225-9031-2-git-send-email-matt@console-pimps.org>
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
> Implement efi_reboot(), which is really just a wrapper around the
> EfiResetSystem() EFI runtime service, but it does at least allow us to
> funnel all callers through a single location.
> 
> It also simplifies the callsites since users no longer need to check to
> see whether EFI_RUNTIME_SERVICES are enabled.
> 
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Mark Salter <msalter@redhat.com>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---

Tested-by: Mark Salter <msalter@redhat.com>

> 
> Mark, I reworked my efi_reboot() to more closely match your versino.
> Since we essentially wrote the same code I'd be happy to include your
> chosen Copyright notice, I just didn't want to be presumptuous and do it
> on your behalf without asking.
> 

Copyright (c) 2014 Red Hat, Inc., Mark Salter <msalter@redhat.com>

Thanks.


