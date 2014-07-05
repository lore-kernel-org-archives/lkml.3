Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbaGEO5n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 10:57:43 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:40913 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbaGEO5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 10:57:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140705004846.GA11659@fieldses.org>
References: <20140704164251.7dc67e07@canb.auug.org.au>
	<CAK5sBcGq54sOSzJKXrEbhAUTZZh=+9NuVh294Qxn0dQvbh-G8w@mail.gmail.com>
	<20140705011058.198ae810@canb.auug.org.au>
	<20140705004846.GA11659@fieldses.org>
Date: Sat, 5 Jul 2014 20:27:39 +0530
Message-ID: <CAK5sBcF72eYPL6=h9JttsWa6MF4cafJb-WO3+JOAh5X4-knKqw@mail.gmail.com>
Subject: Re: linux-next: Tree for Jul 4
From: Sachin Kamat <spk.linux@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 5, 2014 at 6:18 AM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Sat, Jul 05, 2014 at 01:10:58AM +1000, Stephen Rothwell wrote:
>> Hi Sachin,
>>
>> On Fri, 4 Jul 2014 14:12:11 +0530 Sachin Kamat <spk.linux@gmail.com> wrote:
>> >
>> > Was bisecting a kernel crash on Arndale octa board (Exynos5420). It
>> > points to a merge
>> > commit:
>> > 40556a4c485d12d324f1ea196cc30f590e564237 is the first bad commit
>> > ("Merge remote-tracking branch 'nfsd/nfsd-next'").
>> >
>> > How do I proceed with this?
>>
>> I guess we get the owner of the tree (possibly) in question involved
>> (cc'd).
>
> Looking at the total diffstat for that branch, it's almost all contained
> in fs/nfsd with a little in include/linux/sunrpc/ and net/sunrpc.  So
> it's extremely unlikely that it would be causing a problem unless you're
> actually testing nfsd.

I found it surprising too as I do not use nfsd. I will try out the things
suggested by Stephen and update.

-- 
Regards,
Sachin.
