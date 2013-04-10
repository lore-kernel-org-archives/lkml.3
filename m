Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937021Ab3DJP4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:56:44 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:45269 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab3DJP4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:56:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130409151906.2ee55116ca9e3abd80a90e3e@linux-foundation.org>
References: <20130408190738.GC2321@localhost.localdomain> <20130408133712.bd327017dec19a2c14e22662@linux-foundation.org>
 <20130408210039.GA3396@localhost.localdomain> <20130409151906.2ee55116ca9e3abd80a90e3e@linux-foundation.org>
From: Andrew Shewmaker <agshew@gmail.com>
Date: Wed, 10 Apr 2013 09:56:20 -0600
Message-ID: <CAF-E8XHdkqCUJf28z9GMBNUE84Murdsk=T-CoXoXgkLyrwk2-A@mail.gmail.com>
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

I don't know why I didn't think to look for a cross-compiler package first.
Anyway, nommu compiles and links without error when I disable suspend and
switch from slub to slab. Those errors didn't appear to have anything to do
with mm/nommu.c


--
Andrew Shewmaker
