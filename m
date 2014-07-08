Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbaGHIUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:20:33 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:11887 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbaGHIU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:20:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 08 Jul 2014 01:09:44 -0700
Message-ID: <53BBA9C9.8020306@nvidia.com>
Date: Tue, 8 Jul 2014 11:20:25 +0300
From: Mikko Perttunen <mperttunen@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, "tj@kernel.org" <tj@kernel.org>
CC: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v2 6/7] ata: Add support for the Tegra124 SATA controller
References: <1403101406-15439-1-git-send-email-mperttunen@nvidia.com> <1403101406-15439-7-git-send-email-mperttunen@nvidia.com> <53A9D31A.6030307@wwwdotorg.org> <53AC019A.40404@nvidia.com>
In-Reply-To: <53AC019A.40404@nvidia.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Tejun,

the prerequisites for this series have now been acked and it would be 
nice to have it for 3.17. Could you take a look at it?

Thanks,
Mikko

On 26/06/14 14:18, Mikko Perttunen wrote:
> FWIW, from IRC, the series
>
>   > Tested-by: Steev Klimaszewski <steev@gentoo.org>
>
> On 24/06/14 22:35, Stephen Warren wrote:
>> On 06/18/2014 08:23 AM, Mikko Perttunen wrote:
>>> This adds support for the integrated AHCI-compliant Serial ATA
>>> controller present on the NVIDIA Tegra124 system-on-chip.
>>
>> At a quick glance, this looks fine to me now. I'll wait for an ack to
>> take this patch through the Tegra tree, for the reasons I mentioned in
>> response to v1.
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
