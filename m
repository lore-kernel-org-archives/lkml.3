Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965093Ab3DJQmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:42:35 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:42440
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753100Ab3DJQmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:42:33 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(z551bizbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahz8dhz8275bhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1155h)
X-WSS-ID: 0ML1SDQ-02-B4U-02
X-M-MSG: 
Message-ID: <516592EE.8050006@amd.com>
Date: Wed, 10 Apr 2013 11:27:26 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Shuah Khan <shuahkhan@gmail.com>
CC: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 V5] iommu/amd: Add logic to decode AMD IOMMU event
 flag
References: <1365609459-3378-1-git-send-email-suravee.suthikulpanit@amd.com> <CAKocOOML1-=SJGyvYNGK9hyOZp3UPd2WANcWqm1Joo7V6sAQpQ@mail.gmail.com>
In-Reply-To: <CAKocOOML1-=SJGyvYNGK9hyOZp3UPd2WANcWqm1Joo7V6sAQpQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/2013 11:21 AM, Shuah Khan wrote:
> Good feature. Do you also plan to add decode logic for these flags.
> For example, RZ is only meaningful when PR=1, RW is only meaningful
> when
> PR=1, TR=0, and I=0, and so on? This additional logic will be useful.
>
> Reviewed-by: Shuah Khan<shuahkhan@gmail.com>
>
> -- Shuah
Additional filtering logic can also be added in the future.  This will 
also be important if we are planning on handling IOMMU errors.

Suravee

