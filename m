Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaHUTQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:16:55 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37447 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaHUTQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:16:53 -0400
Message-ID: <53F645BA.4000402@wwwdotorg.org>
Date: Thu, 21 Aug 2014 13:17:14 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: balbi@ti.com
CC: tj@kernel.org, thierry.reding@gmail.com, linux-ide@vger.kernel.org,
        linux-tegra@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ata: ahci: tegra: fix build error
References: <20140821190824.GM11146@saruman.home>
In-Reply-To: <20140821190824.GM11146@saruman.home>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 01:08 PM, Felipe Balbi wrote:
> Currently, ahci_tegra doesn't build because it includes a file that
> doesn't exist.
>
> The problem is that first commit 306a7f9 (ARM: tegra: Move includes to
> include/soc/tegra) renamed include/linux/tegra-powergate.h to
> include/soc/tegra/powergate.h.
>
> Later commit 7232398 (ARM: tegra: Convert PMC to a driver) renamed
> include/soc/tegra/powergate.h to include/soc/tegra/pmc.h and neither
> commits fixed drivers/ata/ahci_tegra.c.
>
> Fix that so the driver has a chance of building. With current kernels.
>
> Cc: <stable@vger.kernel.org> # v3.16

This driver first appeared in v3.17-rc1.

This patch has already been sent, and apparently applied:

https://lkml.org/lkml/2014/8/16/36

I wonder if libata/for-3.17-fixes isn't in linux-next?
