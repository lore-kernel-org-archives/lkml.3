Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061Ab3B0Nqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 08:46:33 -0500
Received: from mx0.parallels.com ([199.115.104.20]:45194 "EHLO
	mx0.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760009Ab3B0Nqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 08:46:31 -0500
Message-ID: <512E0E53.9010908@parallels.com>
Date: Wed, 27 Feb 2013 17:46:59 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Christoph Lameter <cl@linux.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v2] slub: correctly bootstrap boot caches
References: <1361550000-14173-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.02.1302221034380.7600@gentwo.org> <alpine.DEB.2.02.1302221057430.7600@gentwo.org> <0000013d02d9ee83-9b41b446-ee42-4498-863e-33b3175c007c-000000@email.amazonses.com> <5127A607.3040603@parallels.com> <0000013d02ee5bf7-a2d47cfc-64fb-4faa-b92e-e567aeb6b587-000000@email.amazonses.com> <CAOJsxLFzrw0pCzUG7Ru4dB9=aPoNKHiJ_y3bopiFvBhzV9A5Zg@mail.gmail.com>
In-Reply-To: <CAOJsxLFzrw0pCzUG7Ru4dB9=aPoNKHiJ_y3bopiFvBhzV9A5Zg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2013 11:47 AM, Pekka Enberg wrote:
> On Fri, Feb 22, 2013 at 7:23 PM, Christoph Lameter <cl@linux.com> wrote:
>> On Fri, 22 Feb 2013, Glauber Costa wrote:
>>
>>> On 02/22/2013 09:01 PM, Christoph Lameter wrote:
>>>> Argh. This one was the final version:
>>>>
>>>> https://patchwork.kernel.org/patch/2009521/
>>>>
>>>
>>> It seems it would work. It is all the same to me.
>>> Which one do you prefer?
>>
>> Flushing seems to be simpler and less code.
> 
> Well, I completely lost track of what to apply... Can someone please
> send me the final version that everybody agrees on with proper ACKs
> and other attributions?
> 
You can apply this one as-is with Christoph's ACK.

