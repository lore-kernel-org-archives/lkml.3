Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab3KWCKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 21:10:46 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34641 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab3KWCKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 21:10:45 -0500
Message-ID: <52900E95.3050106@infradead.org>
Date: Fri, 22 Nov 2013 18:10:29 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Qiang Huang <h.huangqiang@huawei.com>, cl@linux-foundation.org,
        penberg@kernel.org, mpm@selenic.com
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slab: remove the redundant declaration of kmalloc
References: <528DA0C0.8010505@huawei.com> <528E5AEF.6020007@infradead.org> <528EAE3E.5080604@huawei.com>
In-Reply-To: <528EAE3E.5080604@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/13 17:07, Qiang Huang wrote:
> On 2013/11/22 3:11, Randy Dunlap wrote:
>> On 11/20/13 21:57, Qiang Huang wrote:
>>>
>>> Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
>>
>> or use my patch from 2013-09-17:
>> http://marc.info/?l=linux-mm&m=137944291611467&w=2
>>
>> Would be nice to one of these merged...
> 
> Yes, sorry for not notice this, merge your patch should be property :)
> But why it's still not be merged?
> 
> Ping...

I don't know.  I'll resend it now.


Thanks.


-- 
~Randy
