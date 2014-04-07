Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbaDGNTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 09:19:25 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:41967 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274AbaDGNTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 09:19:22 -0400
Date: Mon, 7 Apr 2014 14:19:12 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-efi@vger.kernel.org, matt.fleming@intel.com,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Roy Franz <roy.franz@linaro.org>
Subject: Re: [PATCH 3/5] efi: x86: Improve cmdline conversion
Message-ID: <20140407131912.GG5222@console-pimps.org>
References: <1396614350-20889-1-git-send-email-leif.lindholm@linaro.org>
 <1396614350-20889-4-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396614350-20889-4-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Apr, at 01:25:48PM, Leif Lindholm wrote:
> From: "H. Peter Anvin" <hpa@zytor.com>
> 
> Improve the conversion of the UTF-16 EFI command line
> to UTF-8 for passing to the kernel.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>

This Signed-off-by chain looks a little wonky because it reads as though
the patch was sent by Roy to Peter, who sent it to Leif. Not only that,
I don't have a record of Peter using his zytor.com account to submit
this patch, only his linux.intel.com address.

*rummage* *rummage*.... this is what I have in my inbox,

    From 7d6cf630c1adbb9787a24c2994230373c2b20a8f Mon Sep 17 00:00:00 2001
    From: "H. Peter Anvin" <hpa@linux.intel.com>
    Date: Fri, 20 Sep 2013 09:55:39 -0500
    Subject: [PATCH] efi: Handle arbitrary Unicode characters

    Instead of truncating UTF-16 assuming all characters is ASCII,
    properly convert it to UTF-8.

    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
    ---
     arch/x86/boot/compressed/eboot.c       |  3 +-
     drivers/firmware/efi/efi-stub-helper.c | 89 ++++++++++++++++++++++++++--------
     2 files changed, 71 insertions(+), 21 deletions(-)

It looks like some unnecessary patch munging has gone on here. Now if
Roy has modified Peter's patch in some way, that's fine, but it needs to
be called out in the SoB chain, e.g.

    Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
    [ Add func foobar() and refactored code for XXX ]
    Signed-off-by: Roy Franz <roy.franz@linaro.org>
    Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>

Make sense?

-- 
Matt Fleming, Intel Open Source Technology Center
