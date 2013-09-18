Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab3IRNVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 09:21:24 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:38327 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865Ab3IRNVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 09:21:23 -0400
Date: Wed, 18 Sep 2013 14:21:20 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        matt.fleming@intel.com, leif.lindholm@linaro.org, msalter@redhat.com
Subject: Re: [PATCH V4 00/17] ARM EFI stub common code
Message-ID: <20130918132120.GK3409@console-pimps.org>
References: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379391093-27948-1-git-send-email-roy.franz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Sep, at 09:11:16PM, Roy Franz wrote:
> This patch is the common/x86 portion of the ARM EFI stub
> patchset broken out.  These changes support the addition
> of EFI stub support for the ARM and ARM64 architectures.
> The common code that is now shared in efi-stub-helper.c
> is based on code in the x86 stub that has been generalized
> to support other architectures.

Apart from PATCH 8/17, these all look good to me and work on my test
machines.

If you can respin PATCH 8 based on my comments I'll pull this series
into my efi tree and get it into linux-next.

-- 
Matt Fleming, Intel Open Source Technology Center
