Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbaDFOcK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 10:32:10 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:50700 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbaDFOcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 10:32:01 -0400
Date: Sun, 6 Apr 2014 16:31:58 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        cgroups@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: Re: [GIT PULL] cgroup changes for v3.15-rc1
Message-ID: <20140406143158.GA14380@x4>
References: <20140403164911.GE24119@htj.dyndns.org>
 <CA+55aFyGz2q4iDEt56Bw+x_ri_-DQYLAKPJvk3Uxj9z-y+0uPw@mail.gmail.com>
 <CA+55aFy+Jt0B32kj=Ldz9Krp4DXcXSP4r-o3f-2LPcVs4udGVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFy+Jt0B32kj=Ldz9Krp4DXcXSP4r-o3f-2LPcVs4udGVA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.04.04 at 18:11 -0700, Linus Torvalds wrote:
> On Fri, Apr 4, 2014 at 6:06 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Will report back soon when I've narrowed it down more.
> 
> Ok, that may end up being harder than it looked. Commit
> a755180bab81c038a6989d7ab746c702f1b3ec03 doesn't boot for me at all,
> so apparently there are some really broken points in that whole
> development chain.

FWIW I've seen similar boot failures, that started during this merge
window, on my machine. I first thought they might be linker related so I
opened a bug on: https://sourceware.org/bugzilla/show_bug.cgi?id=16788
But if I remove e.g. a single printk the bug goes away...
Unfortunately the same thing happens if I enable more debugging options,
so I haven't tracked the issue down yet.

-- 
Markus
