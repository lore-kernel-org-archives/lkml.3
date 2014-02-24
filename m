Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaBXSdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:33:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbaBXSdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:33:07 -0500
Date: Mon, 24 Feb 2014 19:32:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 7/7] pid: get pid_t ppid of task in init_pid_ns
Message-ID: <20140224183232.GA21474@redhat.com>
References: <cover.1390495874.git.rgb@redhat.com> <328c85752a7eb053e72d9194827b91fc228d4f67.1390495874.git.rgb@redhat.com> <20140220190114.GC23993@redhat.com> <20140221181055.GE17952@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221181055.GE17952@madcap2.tricolour.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21, Richard Guy Briggs wrote:
>
> On 14/02/20, Oleg Nesterov wrote:
> >
> > imho it would be better to send this patch along with sys_getppid()
> > conversions, but I won't argue.
>
> I don't think sys_getppid() should be changed since it is a syscall
> whose userspace user would assume the working namespace.

Sorry for confusion, I didn't mean we need to change sys_getppid(),

> Many of the
> kernel internal uses of it are likely wrong though, so fixing that
> should probably fall under another patch.  I fixed audit in another
> patch.

Yes, this is what I meant. And this patch should probably go into
that series which fixes the in-kernel users of sys_getppid().

And in fact you already did this? I see another series which resends
this patch as 1/5.

Oleg.

