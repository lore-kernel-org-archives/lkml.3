Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758958AbaLLC01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 21:26:27 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:53103 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaLLC00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 21:26:26 -0500
Message-ID: <548A521B.5020705@hp.com>
Date: Fri, 12 Dec 2014 10:25:31 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Baoquan He <bhe@redhat.com>
CC: Joerg Roedel <joro@8bytes.org>, Takao Indoh <indou.takao@jp.fujitsu.com>,
        dwmw2@infradead.org, vgoyal@redhat.com, dyoung@redhat.com,
        iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, doug.hatch@hp.com,
        jerry.hoemann@hp.com, tom.vaden@hp.com, li.zhang6@hp.com,
        lisa.mitchell@hp.com
Subject: Re: [PATCH 0/5] iommu/vt-d: Fix crash dump failure caused by legacy
 DMA/IO
References: <1413878659-1383-1-git-send-email-zhen-hual@hp.com> <20141022100525.GD9060@dhcp-16-116.nay.redhat.com> <545ACF66.9050509@jp.fujitsu.com> <545AD061.4000102@hp.com> <545AD353.8060207@jp.fujitsu.com> <545AD8D3.90709@hp.com> <545B2885.8070009@jp.fujitsu.com> <545B2C07.1070701@hp.com> <5465A0E0.4020001@hp.com> <20141117133858.GA31920@8bytes.org> <20141210084652.GA25091@dhcp-16-105.nay.redhat.com>
In-Reply-To: <20141210084652.GA25091@dhcp-16-105.nay.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I have no plan yet.
Could you send me your logs on your AMD system?

Thanks
Zhenhua
On 12/10/2014 04:46 PM, Baoquan He wrote:
> Hi Joerg, ZhenHua,
>
> This issue happens on AMD iommu too, do you have any plans or
> thoughts on that?
>
> Thanks
> Baoquan
>
> On 11/17/14 at 02:38pm, Joerg Roedel wrote:
>> On Fri, Nov 14, 2014 at 02:27:44PM +0800, Li, ZhenHua wrote:
>>> I am working following  your directions:
>>>
>>> 1.  If the VT-d driver finds the IOMMU enabled, it reuses its root entry
>>> table, and do NOT disable-enable iommu. Other data will be copied.
>>>
>>> 2. When a device driver issues the first dma_map command for a
>>> device, we assign a new and empty page-table, thus removing all
>>> mappings from the old kernel for the device.
>>>
>>> Please let me know if I get something wrong.
>>
>> Yes, this sounds right. Happily waiting for patches :)
>>
>>
>> 	Joerg
>>

