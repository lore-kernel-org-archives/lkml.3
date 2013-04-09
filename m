Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765455Ab3DIX4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:56:47 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:43814 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764843Ab3DIX4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:56:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130409151906.2ee55116ca9e3abd80a90e3e@linux-foundation.org>
References: <20130408190738.GC2321@localhost.localdomain> <20130408133712.bd327017dec19a2c14e22662@linux-foundation.org>
 <20130408210039.GA3396@localhost.localdomain> <20130409151906.2ee55116ca9e3abd80a90e3e@linux-foundation.org>
From: Andrew Shewmaker <agshew@gmail.com>
Date: Tue, 9 Apr 2013 17:56:25 -0600
Message-ID: <CAF-E8XEq9AE0z472QMWPbY-8YgvDsjx3FhEKRsVx7Bc_=AEn_Q@mail.gmail.com>
Subject: Re: [PATCH v8 3/3] mm: reinititalise user and admin reserves if
 memory is added or removed
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Simon Jeons <simon.jeons@gmail.com>, ric.masonn@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 9, 2013 at 4:19 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 8 Apr 2013 17:00:40 -0400 Andrew Shewmaker <agshew@gmail.com> wrote:
>
>> Should I add the memory notifier code to mm/nommu.c too?
>> I'm guessing that if a system doesn't have an mmu that it also
>> won't be hotplugging memory.
>
> I doubt if we need to worry about memory hotplug on nommu machines,
> so just do the minimum which is required to get nommu to compile
> and link.  That's probably "nothing".

I haven't gotten myself set up to compile a nommu architecture, so I'll post
my next version, and work on verifying it compiles and links later. But I
I probably won't be able to get to that for a week and a half ... I'm leaving
on my honeymoon in the next couple days :)
