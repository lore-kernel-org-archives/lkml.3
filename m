Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451Ab3K2Lxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 06:53:36 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:40028 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752600Ab3K2Lxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 06:53:34 -0500
Date: Fri, 29 Nov 2013 11:53:19 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        matt.fleming@intel.com, grant.likely@linaro.org, roy.franz@linaro.org,
        msalter@redhat.com, patches@linaro.org, linaro-uefi@linaro.org,
        mark.rutland@arm.com
Subject: Re: [PATCH v3 0/3] (U)EFI runtime services for arm
Message-ID: <20131129115319.GC11775@console-pimps.org>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Nov, at 04:41:20PM, Leif Lindholm wrote:
> In systems based on [U]EFI-conformant firmware, runtime services provide
> a standardised way for the kernel to update firmware environment
> variables. This is used for example by efibootmgr to update which image
> should be loaded on next boot.
> 
> This patchset implements basic support for UEFI runtime services on ARM
> platforms, as well as the basic underlying EFI support. It also defines
> a mechanism by which the required information is passed from the
> bootloader (the EFI stub submitted separately) to the kernel via FDT
> entries.

This all looks pretty good to me. Is this series going through the ARM
trees?

-- 
Matt Fleming, Intel Open Source Technology Center
