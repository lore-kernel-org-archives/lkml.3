Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbaDVLyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:54:36 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:42672 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbaDVLyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:54:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140422114838.GK29311@dhcp22.suse.cz>
References: <1397861935-31595-1-git-send-email-nasa4836@gmail.com>
 <20140422094759.GC29311@dhcp22.suse.cz> <CAHz2CGWrk3kuR=BLt2vT-8gxJVtJcj6h17ase9=1CoWXwK6a3w@mail.gmail.com>
 <20140422103420.GI29311@dhcp22.suse.cz> <CAHz2CGUZyv-dvUUoSi2Vk_vgPAMqRN4yEg4F4XsKQ8udHeo2bQ@mail.gmail.com>
 <20140422114838.GK29311@dhcp22.suse.cz>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Tue, 22 Apr 2014 19:53:50 +0800
Message-ID: <CAHz2CGXETcRq3cBDvkPm8JKcRA4qkhJefxz_VsmMouqfsGN5SA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/memcontrol.c: remove meaningless while loop in mem_cgroup_iter()
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Balbir Singh <bsingharora@gmail.com>,
        kamezawa.hiroyu@jp.fujitsu.com, Cgroups <cgroups@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 7:48 PM, Michal Hocko <mhocko@suse.cz> wrote:
> Dunno, this particular case is more explicit but it is also uglier so I
> do not think this is an overall improvement. I would rather keep the
> current state unless the change either simplifies the generated code
> or it is much better to read.

hmm, I agree.  I will give it more thinking.

Seem this has been merged into -mm.  Andrew, please drop it!

Thanks,
Jianyu Zhan
