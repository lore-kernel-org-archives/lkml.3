Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763171Ab3DKJHQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 05:07:16 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63034 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab3DKJHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 05:07:13 -0400
X-AuditID: cbfec7f5-b7fd76d000007247-d5-51667d3e52a5
Message-id: <51667D3D.20103@samsung.com>
Date: Thu, 11 Apr 2013 11:07:09 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 11/30] [media] exynos: remove unnecessary header inclusions
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de>
 <1365638712-1028578-12-git-send-email-arnd@arndb.de>
 <20130410211354.397d5689@redhat.com>
In-reply-to: <20130410211354.397d5689@redhat.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xa7p2tWmBBlf+mFn8nXSM3aJ3wVU2
	i02Pr7FaXN41h82iZ8NWVosZ5/cxWew5epjdgd3j969JjB6bl9R7vN93lc2jb8sqRo/Pm+QC
	WKO4bFJSczLLUov07RK4Mh7vOMxYsJ21YmHzLvYGxm0sXYycHBICJhIPVj1ih7DFJC7cW8/W
	xcjFISSwlFGi7fR+JgjnE6PE/7kb2ECqeAU0JA5+uARmswioSkx7+ZoVxGYTMJToPdrHCGKL
	CgRILF5yjh2iXlDix+R7QNs4OEQE9CS6mgRAZjILnGWUmPd6IytIXFjAX+Lg31yIXXMZJY6s
	PAV2HSfQzHMrzoDNZBbQkdjfOo0NwpaX2LzmLfMERoFZSFbMQlI2C0nZAkbmVYyiqaXJBcVJ
	6blGesWJucWleel6yfm5mxghQf51B+PSY1aHGAU4GJV4eE82pAYKsSaWFVfmHmKU4GBWEuHl
	2gkU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwNj6mdv5WJrRkfhK/bhjkTlrlqcIXtv3Yc+XDacy
	OuyrFqV3/HeIfX3nf6LVqnDn76HhyTrBhw8e+Hx5S0mMa5DRIT4xJ2/L5ui72gXvTsV+9tLY
	cTyI50ueS6Alb8cs91uWhu7cvjE/DgZsfdV0RniiwNrfvm0PxT04kz792PzU2SC6bY8ykxJL
	cUaioRZzUXEiAKqtOw1QAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 02:13 AM, Mauro Carvalho Chehab wrote:
> Em Thu, 11 Apr 2013 02:04:53 +0200
> Arnd Bergmann <arnd@arndb.de> escreveu:
> 
>> In multiplatform configurations, we cannot include headers
>> provided by only the exynos platform. Fortunately a number
>> of drivers that include those headers do not actually need
>> them, so we can just remove the inclusions.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> Cc: linux-media@vger.kernel.org
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

This patch is already queued in the media tree for 3.10, and it can
be found in -next now.

Thanks,
Sylwester

