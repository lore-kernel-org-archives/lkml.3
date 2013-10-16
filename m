Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140Ab3JPQum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 12:50:42 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:21820 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761116Ab3JPQuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 12:50:40 -0400
Message-ID: <1381942237.4324.4.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc/sem.c: fix small codingstyle
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Joe Perches <joe@perches.com>, Libin <huawei.libin@huawei.com>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        guohanjun@huawei.com, xiexiuqi@huawei.com
Date: Wed, 16 Oct 2013 09:50:37 -0700
In-Reply-To: <525E50A6.1070206@colorfullife.com>
References: <1381825183-49576-1-git-send-email-huawei.libin@huawei.com>
	 <1381855484.2354.0.camel@buesod1.americas.hpqcorp.net>
	 <1381862186.22110.33.camel@joe-AO722> <525E50A6.1070206@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-16 at 10:39 +0200, Manfred Spraul wrote:
> Hi Joe,
> 
> On 10/15/2013 08:36 PM, Joe Perches wrote:
> > On Tue, 2013-10-15 at 09:44 -0700, Davidlohr Bueso wrote:
> >> On Tue, 2013-10-15 at 16:19 +0800, Libin wrote:
> >>> From: Li Bin <huawei.libin@huawei.com>
> >>>
> >>> small codingstyle fix: '*' should be adjacent to the data name.
> >> There are *tons* of these, go crazy.
> >>
> > Here are the whitespace changes proposed by
> > $ scripts/checkpatch -f --fix --types=pointer_location,spacing,space_before_tab ipc/*.[ch]
> /me hides, probably most of them are mine.
> 
> Davidlohr: Do you have anything outstanding for ipc/*.c?
> I have nothing.

Nope.

> 
> My proposal would be that the checkpatch -f patch should be added for 
> 3.14, i.e. let's give the code one more cycle to calm down.

I think it would be fine for the 3.13 merge window, but considering all
the action for this release, I have no problem waiting longer.

> Grek just sent me 47 patches for the backport to 3.10-stable, I don't 
> want any whitespace noise right now.

+1

Thanks,
Davidlohr

