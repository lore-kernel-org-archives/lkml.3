Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3FLIOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:14:47 -0400
Received: from mail-db9lp0250.outbound.messaging.microsoft.com ([213.199.154.250]:45383
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752512Ab3FLIOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:14:45 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
X-WSS-ID: 0MO9TKC-01-DJ9-02
X-M-MSG: 
Message-ID: <51B82DEC.8060209@amd.com>
Date: Wed, 12 Jun 2013 03:14:36 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: <suravee.suthikulpanit@amd.com>
CC: <linux-kernel@vger.kernel.org>, <a.p.zijlstra@chello.nl>,
        <mingo@redhat.com>, <iommu@lists.linux-foundation.org>,
        <joro@8bytes.org>
Subject: Re: [PATCH 0/2 V5] perf/x86/amd: IOMMU Performance Counter Support
References: <1370466709-3212-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1370466709-3212-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter/Joerg

Please let me know if you have any questions/concerns about regarding 
this patch set.

Thank you,

Suravee


On 6/5/2013 4:11 PM, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>
> NOTE: Please see individual patch for changes list.
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
>   arch/x86/kernel/cpu/perf_event_amd_iommu.c |  504 ++++++++++++++++++++++++++++
>   arch/x86/kernel/cpu/perf_event_amd_iommu.h |   40 +++
>   drivers/iommu/amd_iommu_init.c             |  140 +++++++-
>   drivers/iommu/amd_iommu_proto.h            |    7 +
>   drivers/iommu/amd_iommu_types.h            |   15 +-
>   6 files changed, 698 insertions(+), 12 deletions(-)
>   create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommu.c
>   create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommu.h
>


