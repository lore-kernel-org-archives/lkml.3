Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab3JQHUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 03:20:13 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59034 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751984Ab3JQHUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 03:20:11 -0400
X-Sasl-enc: M4z/maI2hBvQVbf7kSzx8U5tulqX16rF17lFv7/f9vUH 1381994408
Message-ID: <525F8FA4.3000702@iki.fi>
Date: Thu, 17 Oct 2013 09:20:04 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux.com>, Joonsoo Kim <js1304@gmail.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 00/15] slab: overload struct slab over struct page
 to reduce memory usage
References: <1381913052-23875-1-git-send-email-iamjoonsoo.kim@lge.com> <20131016133457.60fa71f893cd2962d8ec6ff3@linux-foundation.org>
In-Reply-To: <20131016133457.60fa71f893cd2962d8ec6ff3@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/13 10:34 PM, Andrew Morton wrote:
> On Wed, 16 Oct 2013 17:43:57 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
>
>> There is two main topics in this patchset. One is to reduce memory usage
>> and the other is to change a management method of free objects of a slab.
>>
>> The SLAB allocate a struct slab for each slab. The size of this structure
>> except bufctl array is 40 bytes on 64 bits machine. We can reduce memory
>> waste and cache footprint if we overload struct slab over struct page.
> Seems a good idea from a quick look.

Indeed.

Christoph, I'd like to pick this up and queue for linux-next. Any
objections or comments to the patches?

                     Pekka
