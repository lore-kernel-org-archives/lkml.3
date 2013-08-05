Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab3HEMSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 08:18:13 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:33647 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750945Ab3HEMSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 08:18:12 -0400
Date: Mon, 5 Aug 2013 13:18:08 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ia64@vger.kernel.org, matt.fleming@intel.com,
        tony.luck@gmail.com, patches@linaro.org
Subject: Re: [PATCH v2 3/5] efi: x86: use common code for (U)EFI
 configuration scanning
Message-ID: <20130805121808.GQ2515@console-pimps.org>
References: <1375462582-16423-1-git-send-email-leif.lindholm@linaro.org>
 <1375462582-16423-4-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375462582-16423-4-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Aug, at 05:56:20PM, Leif Lindholm wrote:
> This patch makes x86 use the new common code for configuration table
> scanning. It also removes the local definition of the global "efi"
> data structure.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  arch/x86/platform/efi/efi.c |   96 ++++---------------------------------------
>  1 file changed, 8 insertions(+), 88 deletions(-)

Looks good to me.

-- 
Matt Fleming, Intel Open Source Technology Center
