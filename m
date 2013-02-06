Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799Ab3BFSdN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:33:13 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55311 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab3BFSdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:33:09 -0500
MIME-Version: 1.0
In-Reply-To: <51122602.7060307@imgtec.com>
References: <510FE051.7080107@imgtec.com>
	<51100E79.9080101@wwwdotorg.org>
	<alpine.DEB.2.02.1302042019170.32396@gentwo.org>
	<0000013cab3780f7-5e49ef46-e41a-4ff2-88f8-46bf216d677e-000000@email.amazonses.com>
	<51113C8A.2060908@imgtec.com>
	<0000013caba3a2e8-b80a1426-33b5-44ae-9b2a-85c3ee20dd62-000000@email.amazonses.com>
	<51122602.7060307@imgtec.com>
Date: Wed, 6 Feb 2013 20:33:08 +0200
X-Google-Sender-Auth: sBNdDLADwvnsjLFBmXADV5MeXfQ
Message-ID: <CAOJsxLFrJ-GYcsy4m=XoA06tjPpLaBr3HS_g0Cz-YHtsKmWxuA@mail.gmail.com>
Subject: Re: next-20130204 - bisected slab problem to "slab: Common constants
 for kmalloc boundaries"
From: Pekka Enberg <penberg@kernel.org>
To: James Hogan <james.hogan@imgtec.com>
Cc: Christoph Lameter <cl@linux.com>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Matt Mackall <mpm@selenic.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 11:44 AM, James Hogan <james.hogan@imgtec.com> wrote:
> On 05/02/13 18:34, Christoph Lameter wrote:
>> On Tue, 5 Feb 2013, James Hogan wrote:
>>
>>> On 05/02/13 16:36, Christoph Lameter wrote:
>>>> OK I was able to reproduce it by setting ARCH_DMA_MINALIGN in slab.h. This
>>>> patch fixes it here:
>>>>
>>>>
>>>> Subject: slab: Handle ARCH_DMA_MINALIGN correctly
>>>>
>>>> A fixed KMALLOC_SHIFT_LOW does not work for arches with higher alignment
>>>> requirements.
>>>>
>>>> Determine KMALLOC_SHIFT_LOW from ARCH_DMA_MINALIGN instead.
>>>>
>>>> Signed-off-by: Christoph Lameter <cl@linux.com>
>>>
>>> Thanks, your patch fixes it for me.
>>
>> Ok I guess that implies a Tested-by:
>>
>
> Yep sorry, feel free to add my Tested-by: if you roll this as a separate
> patch.

Applied, thanks guys!
