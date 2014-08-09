Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255AbaHIDFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 23:05:18 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:43659 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaHIDFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 23:05:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAH9JG2XuC0A=MVNx=OQcutHaCtXKt=hoWoB9PW3V_PuND6RJ5g@mail.gmail.com>
References: <1407545198-9009-1-git-send-email-xiyou.wangcong@gmail.com>
	<CAH9JG2XuC0A=MVNx=OQcutHaCtXKt=hoWoB9PW3V_PuND6RJ5g@mail.gmail.com>
Date: Fri, 8 Aug 2014 20:05:14 -0700
Message-ID: <CAM_iQpVzs8=8Vf709nObBzdM5GQme41jMW+NY4FXZDN6gd7ptg@mail.gmail.com>
Subject: Re: [Patch] freezer: check OOM kill signal while being frozen
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 7:00 PM, Kyungmin Park <kmpark@infradead.org> wrote:
>
> Similar patch is posted and discussed but no conclusion.
> http://marc.info/?t=137699769400004&r=1&w=1
>

I noticed this thread before sending my patch. I don't think
we are trying to solve the same problem:

a) I only care OOM kill, not other SIGKILL cases
b) I don't set the frozen process state to TASK_KILLABLE
   at all

I think Bartlomiej was trying to make frozen processes
killable by user-space SIGKILL, which is beyond my interest.

Thanks.
