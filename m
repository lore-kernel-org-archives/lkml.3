Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbaGOHCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 03:02:51 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:33385 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767AbaGOHCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 03:02:47 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-5c-53c4d2054a0e
Message-id: <53C4D0BB.2020107@samsung.com>
Date: Tue, 15 Jul 2014 10:56:59 +0400
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Konstantin Serebryany <kcc@google.com>,
        Alexey Preobrazhensky <preobr@google.com>,
        Andrey Konovalov <adech.fo@gmail.com>,
        Yuri Gribov <tetra2005@gmail.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Michal Marek <mmarek@suse.cz>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        x86@kernel.org, linux-mm@kvack.org
Subject: Re: [RFC/PATCH RESEND -next 10/21] mm: slab: share virt_to_cache()
 between slab and slub
References: <1404905415-9046-1-git-send-email-a.ryabinin@samsung.com>
 <1404905415-9046-11-git-send-email-a.ryabinin@samsung.com>
 <20140715055342.GH11317@js1304-P5Q-DELUXE>
In-reply-to: <20140715055342.GH11317@js1304-P5Q-DELUXE>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t/xa7qsl44EGyz9qGDxe+9MVos569ew
	WVz/9obRYsLDNnaLld3NbBbbn71lsljZ+YDVYtPja6wWf3btYLK4vGsOm8W9Nf9ZLW5f5rW4
	dGABk0XLvgtMFm2f/7Fa7Ft5HshaspHJYvGR28wW755NZrbYvGkqs8WPDY9ZHUQ9Wpp72Dx2
	zrrL7rFgU6nHplWdbB6bPk1i9+h6e4XJ4925c+weJ2b8ZvF4cmU6k8fmJfUeH5/eYvF4v+8q
	m8eZBUfYPT5vkgvgi+KySUnNySxLLdK3S+DKuHxtLWNBF3PFjWbOBsYNTF2MnBwSAiYSl9/9
	YIWwxSQu3FvP1sXIxSEksJRRomdtMzOE08wkcWfiWmaQKl4BLYlpa7aygNgsAqoSU2bMYQOx
	2QT0JP7N2g5miwpESBzoe8YKUS8o8WPyPbB6EQENidWrNoMNZRY4zypx/9UvsDOEBZIlFkzc
	ygSxbT2jxO6drWDdnALmEkebXoB1MwvoSOxvncYGYctLbF7zlnkCo8AsJEtmISmbhaRsASPz
	KkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQSP6yg3HxMatDjAIcjEo8vBVih4OFWBPLiitz
	DzFKcDArifB6LD4SLMSbklhZlVqUH19UmpNafIiRiYNTqoGxNHej7OvTM/YrKi2vWCSfW1T+
	IuTNyRyxOhuJY5NMlrmsc9kZ6sRnEbC+5dmuPwtSitZFCgpc7Vwz/eCqHbVmiUn+rzr970XE
	nSqNSSrUezL31Z9nv15NfC3mYay47K168fG7/35oPfvpnOMUVpgh/Tj4ZW9hUJLEppUiyfb/
	jHh5riduiotUYinOSDTUYi4qTgQAqsCTZsICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/14 09:53, Joonsoo Kim wrote:
> On Wed, Jul 09, 2014 at 03:30:04PM +0400, Andrey Ryabinin wrote:
>> This patch shares virt_to_cache() between slab and slub and
>> it used in cache_from_obj() now.
>> Later virt_to_cache() will be kernel address sanitizer also.
> 
> I think that this patch won't be needed.
> See comment in 15/21.
> 

Ok, I'll drop it.

> Thanks.
> 
> 

