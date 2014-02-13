Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaBML0L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 06:26:11 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:41402 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751854AbaBML0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:26:09 -0500
Date: Thu, 13 Feb 2014 11:26:06 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, patches@linaro.org,
        Roy Franz <roy.franz@linaro.org>
Subject: Re: [PATCH 06/22] Add helper functions used by arm/arm64
Message-ID: <20140213112606.GF20717@console-pimps.org>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
 <1391619853-10601-7-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391619853-10601-7-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Feb, at 05:03:57PM, Leif Lindholm wrote:
> From: Roy Franz <roy.franz@linaro.org>
> 
> Add the get_dram_base() function and efi_call_physN() macros
> that are shared by arm/arm64.
> 
> Signed-off-by: Roy Franz <roy.franz@linaro.org>
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  drivers/firmware/efi/efi-stub-helper.c |   63 +++++++++++++++++++++++++-------
>  1 file changed, 50 insertions(+), 13 deletions(-)

These changes should be in drivers/firmware/efi/arm-stub.c -
efi-stub-helper.c is not a dumping ground for random
architecture-specific code.

-- 
Matt Fleming, Intel Open Source Technology Center
