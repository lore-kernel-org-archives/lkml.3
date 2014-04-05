Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaDEBHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 21:07:48 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:36378 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbaDEBG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 21:06:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140403164911.GE24119@htj.dyndns.org>
References: <20140403164911.GE24119@htj.dyndns.org>
Date: Fri, 4 Apr 2014 18:06:54 -0700
X-Google-Sender-Auth: 2u3eBrpd_1Wup3ZsmgaNt-Oc02c
Message-ID: <CA+55aFyGz2q4iDEt56Bw+x_ri_-DQYLAKPJvk3Uxj9z-y+0uPw@mail.gmail.com>
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

On Thu, Apr 3, 2014 at 9:49 AM, Tejun Heo <tj@kernel.org> wrote:
>
> A lot updates for cgroup [...]

Btw, just a heads up to let you know: I'm in the middle of bisecting
why my machine no longer reboots cleanly, and while I'm a few boots
away from pinpointing it exactly, it has now drilled down to the point
that the only remaining commits are from your cgroup pull that I
pulled yesterday.

Maybe I screwed something up in the bisection and it's not 100%
reliable, but I don't think so.

Will report back soon when I've narrowed it down more.

               Linus
