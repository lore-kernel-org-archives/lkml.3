Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3AQNtH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:49:07 -0500
Received: from mout.web.de ([212.227.17.12]:58721 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab3AQNtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:49:06 -0500
Message-ID: <50F800EB.6040104@web.de>
Date: Thu, 17 Jan 2013 14:47:23 +0100
From: Soeren Moch <smoch@web.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Jason Cooper <jason@lakedaemon.net>, Greg KH <gregkh@linuxfoundation.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v2] mm: dmapool: use provided gfp flags for all dma_alloc_coherent()
 calls
References: <20121119144826.f59667b2.akpm@linux-foundation.org> <20130116024014.GH25500@titan.lakedaemon.net> <50F61D86.4020801@web.de> <201301171049.30415.arnd@arndb.de>
In-Reply-To: <201301171049.30415.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:1sromNvyIXotrsIdLN4z/1HF46BHzXEQVhDN7U/flGC
 AvcLGN6+8xlA2Dh2T7grDS7e3jNDd/L4Om55BlIygsLjS8xL+c
 jLOEgw5oe329GTS4qJemXkDTpN/XwpqdDR7hmcEznFgUaINUAZ
 6YmwqL3rSLzlUkC2pq2K981k34coOKPuVowoHg+6VzqNqGV5j2
 meMyn1Tv3ihvN92YN3ilA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.01.2013 11:49, Arnd Bergmann wrote:
> On Wednesday 16 January 2013, Soeren Moch wrote:
>>>> I will see what I can do here. Is there an easy way to track the buffer
>>>> usage without having to wait for complete exhaustion?
>>>
>>> DMA_API_DEBUG
>>
>> OK, maybe I can try this.
>>>
>
> Any success with this? It should at least tell you if there is a
> memory leak in one of the drivers.

Not yet, sorry. I have to do all the tests in my limited spare time.
Can you tell me what to search for in the debug output?

Soeren
