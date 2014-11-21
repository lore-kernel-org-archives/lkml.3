Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbaKUGaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 01:30:21 -0500
Received: from [210.118.77.13] ([210.118.77.13]:45288 "EHLO
	mailout3.w1.samsung.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750766AbaKUGaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 01:30:19 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-ca-546edbe50e8b
Message-id: <546EDBE0.10103@samsung.com>
Date: Fri, 21 Nov 2014 09:29:52 +0300
From: Andrey Ryabinin <a.ryabinin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 1/3] mm: sl[aou]b: introduce kmem_cache_zalloc_node()
References: <1415621218-6438-1-git-send-email-a.ryabinin@samsung.com>
 <alpine.DEB.2.10.1411191545210.32057@chino.kir.corp.google.com>
 <546DAA99.5070402@samsung.com>
 <alpine.DEB.2.10.1411201430220.30354@chino.kir.corp.google.com>
In-reply-to: <alpine.DEB.2.10.1411201430220.30354@chino.kir.corp.google.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xK7pPb+eFGCycLG8xZ/0aNovr394w
	WlzeNYfN4t6a/6wWbZ//AYklG5ksNm+ayuzA7rFgU6nHplWdbB6bPk1i93h37hy7x4kZv1k8
	nlyZzuTxeZNcAHsUl01Kak5mWWqRvl0CV0bbqhtMBdeYK+6cuMXawPiSqYuRk0NCwETiyJ6V
	ULaYxIV769m6GLk4hASWMkpMnz2JHcJpZpK49mgXI0gVr4CGxK/tv1hBbBYBVYl1f3rZQWw2
	AT2Jf7O2s4HYogIRElfWzIGqF5T4MfkeC4gtAtTbNuM/2AZmgXOMElNmXgVbLSzgKTFx8lmo
	1a8YJQ4s/g/UwcHBKeAjMf0jP4jJDLTg/kUtkHJmAXmJzWveMk9gFJiFZMUshKpZSKoWMDKv
	YhRNLU0uKE5KzzXSK07MLS7NS9dLzs/dxAgJ+687GJceszrEKMDBqMTDe2FWbogQa2JZcWXu
	IUYJDmYlEd7yi3khQrwpiZVVqUX58UWlOanFhxiZODilGhidg5afYrpoefXLTtsqv0t7FCbv
	yZL5fHVziN+k0OqtJ9cLnDQVX8S/ZKPaT2Xu9pkF9S3ii2wO/81vbupY+Ynzwk/xf4W9+xaf
	n3qj6r6i09fP2ov3zV0WwRoX7a765F61gTn3wWl9vNa3Q133dsxgtz0apZjkMqmZXTYnq165
	Qvnf07dnZH2UWIozEg21mIuKEwEoAmbpWQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2014 01:31 AM, David Rientjes wrote:
> On Thu, 20 Nov 2014, Andrey Ryabinin wrote:
> 
>>> Is there a reason to add this for such a specialized purpose to the slab 
>>> allocator?  I think it can just be handled for struct irq_desc explicitly.
>>>
>>
>> It could be used not only for irq_desc. Grepping sources gave me 7 possible users.
>>
> 
> It would be best to follow in the example of those users and just use 
> __GFP_ZERO.
> 

Fair enough.
