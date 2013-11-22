Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab3KVRSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:18:24 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48659 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab3KVRSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:18:22 -0500
MIME-Version: 1.0
In-Reply-To: <20131122073851.GB1853@hp530>
References: <1384965522-5788-1-git-send-email-ddstreet@ieee.org>
 <20131120173347.GA2369@hp530> <CALZtONA81=R4abFMpMMtDZKQe0s-8+JxvEfZO3NEZ910VwRDmw@mail.gmail.com>
 <20131122073851.GB1853@hp530>
From: Dan Streetman <ddstreet@ieee.org>
Date: Fri, 22 Nov 2013 12:18:01 -0500
X-Google-Sender-Auth: CZaanRi-0BQy37omthUWocWYzBI
Message-ID: <CALZtONA-CdTJ=cg3cnacEz0uDtQVinkqkyPQuNSCWT18OD+Y5w@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: change params from hidden to ro
To: Vladimir Murzin <murzin.v@gmail.com>
Cc: linux-mm@kvack.org, Seth Jennings <sjennings@variantweb.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bob Liu <bob.liu@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 2:38 AM, Vladimir Murzin <murzin.v@gmail.com> wrote:
> On Wed, Nov 20, 2013 at 12:52:47PM -0500, Dan Streetman wrote: > On Wed, Nov
> 20, 2013 at 12:33 PM, Vladimir Murzin <murzin.v@gmail.com> wrote: > > Hi Dan!
>> >
>> > On Wed, Nov 20, 2013 at 11:38:42AM -0500, Dan Streetman wrote:
>> >> The "compressor" and "enabled" params are currently hidden,
>> >> this changes them to read-only, so userspace can tell if
>> >> zswap is enabled or not and see what compressor is in use.
>> >
>> > Could you elaborate more why this pice of information is necessary for
>> > userspace?
>>
>> For anyone interested in zswap, it's handy to be able to tell if it's
>> enabled or not ;-)  Technically people can check to see if the zswap
>> debug files are in /sys/kernel/debug/zswap, but I think the actual
>> "enabled" param is more obvious.  And the compressor param is really
>> the only way anyone from userspace can see what compressor's being
>> used; that's helpful to know for anyone that might want to be using a
>> non-default compressor.
>
> So, it is needed for user not userspace? I tend to think that users are smart
> enough to check cmdline for that.

Let's try a different way.  Can you explain what the problem is with
making these params user-readable?
