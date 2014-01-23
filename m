Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaAWUoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 15:44:01 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:61817 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaAWUoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 15:44:00 -0500
MIME-Version: 1.0
In-Reply-To: <20140122123358.a65c42605513fc8466152801@linux-foundation.org>
References: <1387459407-29342-1-git-send-email-ddstreet@ieee.org>
 <20140114001115.GU1992@bbox> <CALZtONCCrckuHxgHB=GQj0tHszLAYTZZLGzFTnRkj9pvxx0dyg@mail.gmail.com>
 <20140115054208.GL1992@bbox> <CALZtONCehE8Td2C2w-fOC596uD54y1-kyc3SiKABBEODMb+a7Q@mail.gmail.com>
 <CALZtONAaPCi8eUhSmdXSxWbeFFN=ChsfL9OurSZUsSPo-_gnfg@mail.gmail.com> <20140122123358.a65c42605513fc8466152801@linux-foundation.org>
From: Dan Streetman <ddstreet@ieee.org>
Date: Thu, 23 Jan 2014 15:43:37 -0500
X-Google-Sender-Auth: 7uKY9FPS-OCN7bnkWQWumviSZXM
Message-ID: <CALZtONCteZPFaAG0oXQGnmDocnVmpmxBeGzYMa3B_4QpGSgCvw@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: add writethrough option
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Seth Jennings <sjennings@variantweb.net>, Minchan Kim <minchan@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Weijie Yang <weijie.yang@samsung.com>,
        Shirish Pargaonkar <spargaonkar@suse.com>,
        Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 3:33 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 22 Jan 2014 09:19:58 -0500 Dan Streetman <ddstreet@ieee.org> wrote:
>
>> >>> > Acutally, I really don't know how much benefit we have that in-memory
>> >>> > swap overcomming to the real storage but if you want, zRAM with dm-cache
>> >>> > is another option rather than invent new wheel by "just having is better".
>> >>>
>> >>> I'm not sure if this patch is related to the zswap vs. zram discussions.  This
>> >>> only adds the option of using writethrough to zswap.  It's a first
>> >>> step to possibly
>> >>> making zswap work more efficiently using writeback and/or writethrough
>> >>> depending on
>> >>> the system and conditions.
>> >>
>> >> The patch size is small. Okay I don't want to be a party-pooper
>> >> but at least, I should say my thought for Andrew to help judging.
>> >
>> > Sure, I'm glad to have your suggestions.
>>
>> To give this a bump - Andrew do you have any concerns about this
>> patch?  Or can you pick this up?
>
> I don't pay much attention to new features during the merge window,
> preferring to shove them into a folder to look at later.  Often they
> have bitrotted by the time -rc1 comes around.
>
> I'm not sure that this review discussion has played out yet - is
> Minchan happy?

I think so, or at least ok enough to not block it, but please correct
me if I am wrong, Minchan.

>
> Please update the changelog so that it reflects the questions Minchan
> asked (any reviewer question should be regarded as an inadequacy in
> either the code commenting or the changelog - people shouldn't need to
> ask the programmer why he did something!) and resend for -rc1?

OK I'll update and resend.
