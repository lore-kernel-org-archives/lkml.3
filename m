Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab3BFJoo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 04:44:44 -0500
Received: from multi.imgtec.com ([194.200.65.239]:61053 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab3BFJok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 04:44:40 -0500
Message-ID: <51122602.7060307@imgtec.com>
Date: Wed, 6 Feb 2013 09:44:34 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        <linux-mm@kvack.org>
Subject: Re: next-20130204 - bisected slab problem to "slab: Common constants
 for kmalloc boundaries"
References: <510FE051.7080107@imgtec.com> <51100E79.9080101@wwwdotorg.org> <alpine.DEB.2.02.1302042019170.32396@gentwo.org> <0000013cab3780f7-5e49ef46-e41a-4ff2-88f8-46bf216d677e-000000@email.amazonses.com> <51113C8A.2060908@imgtec.com> <0000013caba3a2e8-b80a1426-33b5-44ae-9b2a-85c3ee20dd62-000000@email.amazonses.com>
In-Reply-To: <0000013caba3a2e8-b80a1426-33b5-44ae-9b2a-85c3ee20dd62-000000@email.amazonses.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_02_06_09_44_36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/13 18:34, Christoph Lameter wrote:
> On Tue, 5 Feb 2013, James Hogan wrote:
> 
>> On 05/02/13 16:36, Christoph Lameter wrote:
>>> OK I was able to reproduce it by setting ARCH_DMA_MINALIGN in slab.h. This
>>> patch fixes it here:
>>>
>>>
>>> Subject: slab: Handle ARCH_DMA_MINALIGN correctly
>>>
>>> A fixed KMALLOC_SHIFT_LOW does not work for arches with higher alignment
>>> requirements.
>>>
>>> Determine KMALLOC_SHIFT_LOW from ARCH_DMA_MINALIGN instead.
>>>
>>> Signed-off-by: Christoph Lameter <cl@linux.com>
>>
>> Thanks, your patch fixes it for me.
> 
> Ok I guess that implies a Tested-by:
> 

Yep sorry, feel free to add my Tested-by: if you roll this as a separate
patch.

Cheers
James

