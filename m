Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab3ETPln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:41:43 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:1068
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756276Ab3ETPli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 11:41:38 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1155h)
X-WSS-ID: 0MN3SX2-02-5DP-02
X-M-MSG: 
Message-ID: <519A4429.30405@amd.com>
Date: Mon, 20 May 2013 10:41:29 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: <suravee.suthikulpanit@amd.com>
CC: <linux-kernel@vger.kernel.org>, <a.p.zijlstra@chello.nl>,
        <mingo@redhat.com>, <iommu@lists.linux-foundation.org>,
        <joro@8bytes.org>
Subject: Re: [PATCH 0/2 V3] perf/x86/amd: IOMMU Performance Counter Support
References: <1368819813-6481-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1368819813-6481-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

Please let me know if you have any questions/concerns regarding the PMU 
implementation.

Joerg,
Please let me know if you have any questions/concerns regarding the 
changes in the IOMMU driver.

Thank you,

Suravee

On 5/17/2013 2:43 PM, suravee.suthikulpanit@amd.com wrote:
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
>   arch/x86/kernel/cpu/Makefile               |    2 +-
>   arch/x86/kernel/cpu/perf_event_amd_iommu.c |  500 ++++++++++++++++++++++++++++
>   arch/x86/kernel/cpu/perf_event_amd_iommu.h |   40 +++
>   drivers/iommu/amd_iommu_init.c             |  121 ++++++-
>   drivers/iommu/amd_iommu_proto.h            |    7 +
>   drivers/iommu/amd_iommu_types.h            |   12 +-
>   6 files changed, 675 insertions(+), 7 deletions(-)
>   create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommu.c
>   create mode 100644 arch/x86/kernel/cpu/perf_event_amd_iommu.h
>


