Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab3EaXJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 19:09:06 -0400
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:15558
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756836Ab3EaXJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 19:09:00 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I1432I4015Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
X-WSS-ID: 0MNOQYT-02-8ZG-02
X-M-MSG: 
Message-ID: <51A92D85.9040901@amd.com>
Date: Fri, 31 May 2013 18:08:53 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: <suravee.suthikulpanit@amd.com>, <joro@8bytes.org>
CC: <linux-kernel@vger.kernel.org>, <a.p.zijlstra@chello.nl>,
        <mingo@redhat.com>, <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH 0/2 V4] perf/x86/amd: IOMMU Performance Counter Support
References: <1369781112-2198-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1369781112-2198-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jorge,

Please let me know if you have any other questions/concerns.

Thanks,

Suravee

On 5/28/2013 5:45 PM, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>
> These patches implement the AMD IOMMU Performance Counter functionality
> via custom perf PMU and implement static counting for various IOMMU
> translations.
>
>      1) Extend the AMD IOMMU initialization to include performance
>         counter enablement.
>
>      2) The perf AMD IOMMU PMU to manage performance counters, which
>         interface with the AMD IOMMU core driver.
>
> Steven L Kinney (1):
>    perf/x86/amd: Adding IOMMU PC resource management
>
> Suravee Suthikulpanit (1):
>    perf/x86/amd: AMD IOMMU PC PERF uncore PMU implementation
>
>   arch/x86/kernel/cpu/Makefile               |    4 +
>   arch/x86/kernel/cpu/perf_event_amd_iommu.c |  500 ++++++++++++++++++++++++++++
>   arch/x86/kernel/cpu/perf_event_amd_iommu.h |   40 +++
>   drivers/iommu/amd_iommu_init.c             |  140 +++++++-
>   drivers/iommu/amd_iommu_proto.h            |    7 +
>   drivers/iommu/amd_iommu_types.h            |   15 +-
>   6 files changed, 694 insertions(+), 12 deletions(-)
>   create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommu.c
>   create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommu.h
>


