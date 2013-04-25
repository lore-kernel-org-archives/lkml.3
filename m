Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab3DYOw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:52:58 -0400
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:21975
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756916Ab3DYOw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:52:57 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h947he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1889i1155h)
X-WSS-ID: 0MLTFYV-01-7KB-02
X-M-MSG: 
Message-ID: <51794317.5090309@amd.com>
Date: Thu, 25 Apr 2013 09:52:07 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: <suravee.suthikulpanit@amd.com>, <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] iommu/amd: iommu/amd: Show detail event log when
 using amd-iommu=verbose
References: <1365609424-3315-1-git-send-email-suravee.suthikulpanit@amd.com>
In-Reply-To: <1365609424-3315-1-git-send-email-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg,

Do you have any other concerns about this patch set?

Thank you,

Suravee

On 4/10/2013 10:57 AM, suravee.suthikulpanit@amd.com wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>
> This patch set add detail event log information for AMD IOMMU in dmesg when booting with
> "amd-iommu=verbose".
>
> Suravee Suthikulpanit (2):
>    iommu/amd: Adding new command line option "amd-iommu=verbose"
>    iommu/amd: Add logic to decode AMD IOMMU event flag
>
>   drivers/iommu/amd_iommu.c       |  215 ++++++++++++++++++++++++++++++---------
>   drivers/iommu/amd_iommu_init.c  |    4 +
>   drivers/iommu/amd_iommu_types.h |    2 +
>   3 files changed, 174 insertions(+), 47 deletions(-)
>


