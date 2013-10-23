Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3JWNFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:05:33 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:32989 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab3JWNFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:05:32 -0400
Date: Wed, 23 Oct 2013 14:05:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Andreas Werner <andreas.werner@men.de>
Subject: Re: [PATCH] mfd: lpc_sch: Ignore resource conflicts when adding mfd
 cells
Message-ID: <20131023130527.GE2620@lee--X1>
References: <1382527860-8959-1-git-send-email-johannes.thumshirn@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382527860-8959-1-git-send-email-johannes.thumshirn@men.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Oct 2013, Johannes Thumshirn wrote:

> Currently probe of lpc_sch fails on Intel Poulsbo because of ACPI resource
> conflicts. A solution is to  set the ignore_resource_conflicts flag in the mfd cells.
> 
> Tested-by: Andreas Werner <andreas.werner@men.de>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> ---
>  drivers/mfd/lpc_sch.c |    3 +++
>  1 file changed, 3 insertions(+)

I'm okay with this change. I'll apply it until someone else complains.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
