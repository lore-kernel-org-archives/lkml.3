Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaDEBLu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 21:11:50 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:60765 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbaDEBLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 21:11:48 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyGz2q4iDEt56Bw+x_ri_-DQYLAKPJvk3Uxj9z-y+0uPw@mail.gmail.com>
References: <20140403164911.GE24119@htj.dyndns.org>
	<CA+55aFyGz2q4iDEt56Bw+x_ri_-DQYLAKPJvk3Uxj9z-y+0uPw@mail.gmail.com>
Date: Fri, 4 Apr 2014 18:11:47 -0700
X-Google-Sender-Auth: wJt23xtzf4hkWTlkQX-FqkM-zAE
Message-ID: <CA+55aFy+Jt0B32kj=Ldz9Krp4DXcXSP4r-o3f-2LPcVs4udGVA@mail.gmail.com>
Subject: Re: [GIT PULL] cgroup changes for v3.15-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        cgroups@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 4, 2014 at 6:06 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Will report back soon when I've narrowed it down more.

Ok, that may end up being harder than it looked. Commit
a755180bab81c038a6989d7ab746c702f1b3ec03 doesn't boot for me at all,
so apparently there are some really broken points in that whole
development chain.

I'll try to pick kernels away from that, but that makes bisection much
less effective.

                Linus
