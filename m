Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933121AbaHYRXH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:23:07 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35851 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933093AbaHYRXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:23:05 -0400
Message-ID: <53FB7111.2000602@wwwdotorg.org>
Date: Mon, 25 Aug 2014 11:23:29 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>
CC: thierry.reding@gmail.com, tj@kernel.org, hdegoede@redhat.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v3 2/8] ARM: tegra: Add SATA controller to Tegra124 device
 tree
References: <1405500863-19696-1-git-send-email-mperttunen@nvidia.com> <1405500863-19696-3-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1405500863-19696-3-git-send-email-mperttunen@nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 02:54 AM, Mikko Perttunen wrote:
> This adds the integrated AHCI-compliant Serial ATA controller present
> in Tegra124 systems-on-chip to the Tegra124 device tree.

I have applied patches 2 and 3 to Tegra's for-3.18/dt branch. I fixed 
the DT node sort order when doing so.

I can't apply patch 8 (the defconfig change) until 3.17-rc2 is out, or 
there will be a build failure, but I will do so ASAP.

BTW, once 3.17-rc2 is out, can you please sent a patch to 
multi_v7_defconfig enabling Tegra SATA support there too. Thanks.
