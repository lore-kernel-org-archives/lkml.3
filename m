Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218AbaFYBIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 21:08:32 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:50053 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752205AbaFYBIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 21:08:30 -0400
X-IronPort-AV: E=Sophos;i="5.00,772,1396972800"; 
   d="scan'208";a="32386321"
Message-ID: <53AA1E5F.10800@cn.fujitsu.com>
Date: Wed, 25 Jun 2014 08:57:03 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Li Zefan <lizefan@huawei.com>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Cgroups <cgroups@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] mm/mempolicy: fix sleeping function called from invalid
 context
References: <53902A44.50005@cn.fujitsu.com> <20140605132339.ddf6df4a0cf5c14d17eb8691@linux-foundation.org> <539192F1.7050308@cn.fujitsu.com> <alpine.DEB.2.02.1406081539140.21744@chino.kir.corp.google.com> <539574F1.2060701@cn.fujitsu.com> <alpine.DEB.2.02.1406090209460.24247@chino.kir.corp.google.com> <53967465.7070908@huawei.com> <20140620210137.GA2059@mtj.dyndns.org> <53A8E23C.4050103@huawei.com> <20140624205832.GB14909@htj.dyndns.org>
In-Reply-To: <20140624205832.GB14909@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,
On 06/25/2014 04:58 AM, Tejun Heo wrote:

> Hello,
> 
> On Tue, Jun 24, 2014 at 10:28:12AM +0800, Li Zefan wrote:
>>> I don't think the suggested patch breaks anything more than it was
>>> broken before and we should probably apply it for the time being.  Li?
>>
>> Yeah, we should apply Gu Zheng's patch any way.
> 
> Gu Zheng, can you please respin the patch with updated explanation on
> the temporary nature of the change.  I'll apply it once Li acks it.

OK, I'll resend it soon.

Regards,
Gu

> 
> Thanks.
> 


