Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbaHDSlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 14:41:50 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31121 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaHDSlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 14:41:49 -0400
Message-ID: <53DFD3DA.4060302@oracle.com>
Date: Mon, 04 Aug 2014 14:41:30 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Christoph Lameter <cl@gentwo.org>, Tejun Heo <htejun@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Matt Mackall <mpm@selenic.com>, Gilad Ben-Yossef <gilad@benyossef.com>,
        Jens Axboe <axboe@fb.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: kernel: smp: WARNING at kernel/smp.c:673
References: <53DEF67E.8090004@oracle.com> <alpine.DEB.2.11.1408041000040.8248@gentwo.org> <20140804150356.GE26230@htj.dyndns.org> <alpine.DEB.2.11.1408041020590.9249@gentwo.org> <20140804152251.GF26230@htj.dyndns.org> <alpine.DEB.2.11.1408041100240.9968@gentwo.org>
In-Reply-To: <alpine.DEB.2.11.1408041100240.9968@gentwo.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2014 12:00 PM, Christoph Lameter wrote:
> On Mon, 4 Aug 2014, Tejun Heo wrote:
> 
>>> Yuck. I meant cgroup code. There were some patches that were suggesting a
>>> shrink operation when taking down a cgroup. Does that also apply to per
>>> cpu downing?
>>
>> Heh, I have no idea what you're talking about.  cgroup currently
>> doesn't do anything like that.  It doesn't even make use of the cpu
>> hotplug hooks.
> 
> Something is running a kmem_cache_shrink from cpu down hooks. Thats weird.
> 

That's not cpu down, that's mem down.


Thanks,
Sasha
