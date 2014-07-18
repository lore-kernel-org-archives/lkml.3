Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761494AbaGRKuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 06:50:00 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:18035 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761329AbaGRKt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 06:49:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 18 Jul 2014 03:38:30 -0700
Message-ID: <53C8FBD2.9@nvidia.com>
Date: Fri, 18 Jul 2014 13:49:54 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "tj@kernel.org" <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v5 7/8] ata: Add support for the Tegra124 SATA controller
References: <1405500863-19696-8-git-send-email-mperttunen@nvidia.com> <1405667550-7707-1-git-send-email-mperttunen@nvidia.com> <53C8F65C.2020800@redhat.com>
In-Reply-To: <53C8F65C.2020800@redhat.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!

- Mikko

On 18/07/14 13:26, Hans de Goede wrote:
> Hi,
>
> On 07/18/2014 09:12 AM, Mikko Perttunen wrote:
>> This adds support for the integrated AHCI-compliant Serial ATA
>> controller present on the NVIDIA Tegra124 system-on-chip.
>>
>> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
>> ---
>> v5: let ahci_platform handle sata clock and also handle it ourselves.
>>    this allows use of ahci_platform while having a special sequence
>>    for the clock.
>
> Thanks, I like this one, much better then what we had before.
>
> Acked-by: Hans de Goede <hdegoede@redhat.com>
>
> Regards,
>
> Hans
>
>
>
 >> ...

