Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab3EWBYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 21:24:30 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:21298 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662Ab3EWBY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 21:24:29 -0400
Message-ID: <519D6FAC.6010609@huawei.com>
Date: Thu, 23 May 2013 09:23:56 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: <ohad@wizery.com>, <joerg.roedel@amd.com>,
        LKML <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        <Varun.Sethi@freescale.com>, <iommu@lists.linux-foundation.org>,
        <mingo@kernel.org>, <ddutile@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH] msm: iommu: fix leak and invalid access
References: <51931347.7020600@huawei.com> <519C5E8F.7060006@huawei.com> <20130522222942.GA5706@codeaurora.org>
In-Reply-To: <20130522222942.GA5706@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/23 6:29, David Brown wrote:
> On Wed, May 22, 2013 at 01:58:39PM +0800, Libo Chen wrote:
> 
>> > ping...
> This is the first I've seen this patch.  The original appears to have
> been sent to Andrew Morton and lkml.  I'll reply with an Ack there.
> 
> David

Regards

Libo

