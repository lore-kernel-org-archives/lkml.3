Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935400Ab3DJAL1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 20:11:27 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:46401 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab3DJALZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 20:11:25 -0400
MIME-Version: 1.0
In-Reply-To: <5164ACBB.2040704@gmail.com>
References: <20130408190738.GC2321@localhost.localdomain> <20130408133712.bd327017dec19a2c14e22662@linux-foundation.org>
 <20130408210039.GA3396@localhost.localdomain> <20130409151906.2ee55116ca9e3abd80a90e3e@linux-foundation.org>
 <CAF-E8XEq9AE0z472QMWPbY-8YgvDsjx3FhEKRsVx7Bc_=AEn_Q@mail.gmail.com> <5164ACBB.2040704@gmail.com>
From: Andrew Shewmaker <agshew@gmail.com>
Date: Tue, 9 Apr 2013 18:11:04 -0600
Message-ID: <CAF-E8XEGz4Q7-KWP8-cam1x4vQmpy-s_j3CAW6sUe4T5f_vsoQ@mail.gmail.com>
Subject: Re: [PATCH v8 3/3] mm: reinititalise user and admin reserves if
 memory is added or removed
To: Simon Jeons <simon.jeons@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        ric.masonn@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 6:05 PM, Simon Jeons <simon.jeons@gmail.com> wrote:
> Hi Andrew,
>
> On 04/10/2013 07:56 AM, Andrew Shewmaker wrote:
>>
>> On Tue, Apr 9, 2013 at 4:19 PM, Andrew Morton <akpm@linux-foundation.org>
>> wrote:
>>>
>>> On Mon, 8 Apr 2013 17:00:40 -0400 Andrew Shewmaker <agshew@gmail.com>
>>> wrote:
>>>
>>>> Should I add the memory notifier code to mm/nommu.c too?
>>>> I'm guessing that if a system doesn't have an mmu that it also
>>>> won't be hotplugging memory.
>>>
>>> I doubt if we need to worry about memory hotplug on nommu machines,
>>> so just do the minimum which is required to get nommu to compile
>>> and link.  That's probably "nothing".
>>
>> I haven't gotten myself set up to compile a nommu architecture, so I'll
>> post
>> my next version, and work on verifying it compiles and links later. But I
>> I probably won't be able to get to that for a week and a half ... I'm
>> leaving
>> on my honeymoon in the next couple days :)
>
>
> How to compile a  nommu architecture? just config in menu config or a
> physical machine?

I was going to set up a qemu arm guest. Please, anyone, let me know if
there's an easier way to test nommu builds on x86.
