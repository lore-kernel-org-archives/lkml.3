Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbaDEBeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 21:34:11 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:55831 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbaDEBeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 21:34:06 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFy+Jt0B32kj=Ldz9Krp4DXcXSP4r-o3f-2LPcVs4udGVA@mail.gmail.com>
References: <20140403164911.GE24119@htj.dyndns.org>
	<CA+55aFyGz2q4iDEt56Bw+x_ri_-DQYLAKPJvk3Uxj9z-y+0uPw@mail.gmail.com>
	<CA+55aFy+Jt0B32kj=Ldz9Krp4DXcXSP4r-o3f-2LPcVs4udGVA@mail.gmail.com>
Date: Fri, 4 Apr 2014 18:34:05 -0700
X-Google-Sender-Auth: f1TussqFfF-ktK0j4zKXc418YJg
Message-ID: <CA+55aFwM0aG1PHY7xOQbsFG+Ot4mL4=7yRnT7dssUaOyaLQ3GQ@mail.gmail.com>
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

On Fri, Apr 4, 2014 at 6:11 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'll try to pick kernels away from that, but that makes bisection much
> less effective.

Ok, I think I'm away from the broken region. The problem seems to be in between

good: 8e30e2b8ba0e ("cgroup: restructure locking and error handling in
cgroup_mount()")

bad: 6f30558f37bf ("cgroup: make cgroup hold onto its kernfs_node")

and let's see what bisect says about the rest.. Does that give you any ideas?

            Linus
