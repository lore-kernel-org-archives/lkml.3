Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbaEIHOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:14:30 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:37956 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaEIHO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:14:28 -0400
Date: Fri, 9 May 2014 08:14:23 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chris Ball <chris@printf.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Micky Ching <micky_ching@realsil.com.cn>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: linux-next: manual merge of the mmc tree with Linus' tree
Message-ID: <20140509071423.GF5767@lee--X1>
References: <20140509134455.07d7de4d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140509134455.07d7de4d@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Today's linux-next merge of the mmc tree got a conflict in
> drivers/mmc/host/rtsx_pci_sdmmc.c between commit 98fcc5762dce ("mmc:
> rtsx: Revert "mmc: rtsx: add support for pre_req and post_req"") from
> the  tree and commit 1f7b581b3ffc ("mmc: rtsx: modify error handle and
> remove smatch warnings") from the mmc tree.
> 
> I fixed it up (maybe - see below and in the final tree) and can carry
> the fix as necessary (no action is required).

FYI: From what Ulf (co-maintainer of MMC) says, this was expected and
will continue to happen until a pending revert is merged.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
