Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbaHZHOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:14:21 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:13247 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbaHZHOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:14:18 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 26 Aug 2014 00:00:07 -0700
Message-ID: <53FC33C6.6010607@nvidia.com>
Date: Tue, 26 Aug 2014 10:14:14 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: <thierry.reding@gmail.com>, <tj@kernel.org>, <hdegoede@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v3 2/8] ARM: tegra: Add SATA controller to Tegra124 device
 tree
References: <1405500863-19696-1-git-send-email-mperttunen@nvidia.com> <1405500863-19696-3-git-send-email-mperttunen@nvidia.com> <53FB7111.2000602@wwwdotorg.org>
In-Reply-To: <53FB7111.2000602@wwwdotorg.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/08/14 20:23, Stephen Warren wrote:
> On 07/16/2014 02:54 AM, Mikko Perttunen wrote:
>> This adds the integrated AHCI-compliant Serial ATA controller present
>> in Tegra124 systems-on-chip to the Tegra124 device tree.
>
> I have applied patches 2 and 3 to Tegra's for-3.18/dt branch. I fixed
> the DT node sort order when doing so.

Thanks :)

>
> I can't apply patch 8 (the defconfig change) until 3.17-rc2 is out, or
> there will be a build failure, but I will do so ASAP.
>
> BTW, once 3.17-rc2 is out, can you please sent a patch to
> multi_v7_defconfig enabling Tegra SATA support there too. Thanks.

Will do.

Cheers,
Mikko
