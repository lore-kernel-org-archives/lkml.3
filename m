Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbaKNIMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:12:39 -0500
Received: from g2t2354.austin.hp.com ([15.217.128.53]:21844 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaKNIMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:12:38 -0500
Message-ID: <5465B952.3010702@hp.com>
Date: Fri, 14 Nov 2014 16:12:02 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Baoquan He <bhe@redhat.com>
CC: "Li, ZhenHua" <zhen-hual@hp.com>, Minfei Huang <mhuang@redhat.com>,
        kexec@lists.infradead.org, joro@8bytes.org, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] x86/iommu: fix incorrect bit operations in setting
 values
References: <1415172619-4801-1-git-send-email-zhen-hual@hp.com> <20141112112832.GA3334@dhcp-17-108.nay.redhat.com> <546474AF.2030902@hp.com> <20141113133708.GA1678@dhcp-17-102.nay.redhat.com> <54655B0F.5070204@hp.com>
In-Reply-To: <54655B0F.5070204@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 1st step shows we should NOT disable the iommu when it is already
> enabled. But current code does disable-enable. So there is still works
> to do.
>

The original kernel does a disable and re-enable , Bill's patchset 
removed the disable operation.

> I think step 2 is necessary, because when the driver initializes, the
> device need a new map, and the old data from the old kernel can not be
> used for the new driver.
>
> Now I am trying to implement these ideas.
>
>> Thanks
