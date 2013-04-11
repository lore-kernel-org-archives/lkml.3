Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab3DKVkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:40:22 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:44149
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678Ab3DKVkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:40:20 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2dh668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1155h)
X-WSS-ID: 0ML41IV-01-6EO-02
X-M-MSG: 
Message-ID: <51672DB7.4010403@amd.com>
Date: Thu, 11 Apr 2013 16:40:07 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: <iommu@lists.linux-foundation.org>, Borislav Petkov <bp@suse.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/9] iommu/amd: Add ioapic and hpet ivrs override
References: <1365538384-12426-1-git-send-email-joro@8bytes.org> <1365538384-12426-8-git-send-email-joro@8bytes.org> <20130409202941.GJ6858@8bytes.org>
In-Reply-To: <20130409202941.GJ6858@8bytes.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/9/2013 3:29 PM, Joerg Roedel wrote:
> On Tue, Apr 09, 2013 at 10:13:02PM +0200, Joerg Roedel wrote:
>> Add two new kernel commandline parameters ivrs_ioapic and
>> ivrs_hpet to override the Id->DeviceId mapping from the IVRS
>> ACPI table. This can be used to work around broken BIOSes to
>> get interrupt remapping working on AMD systems.
>>
>> Signed-off-by: Joerg Roedel <joro@8bytes.org>
> Forgot to add:
>
> Tested-by: Borislav Petkov <bp@suse.de>
I also tested on some other systems here and the patch works also.

Suravee
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/iommu
>


