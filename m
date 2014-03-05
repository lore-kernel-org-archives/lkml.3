Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbaCEQoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:44:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752109AbaCEQoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:44:04 -0500
Date: Wed, 5 Mar 2014 17:12:27 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, venki@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
Message-ID: <20140305161227.GA1713@redhat.com>
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <20140304135624.GA6846@redhat.com> <53161116.9050109@oracle.com> <20140304190348.GA22075@redhat.com> <5316343B.2030404@oracle.com> <20140305143800.GA29480@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305143800.GA29480@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05, Oleg Nesterov wrote:
>
> You added /proc/sched_preempt_delay to avoid the syscall. I think it
> would be better to simply add vdso_sched_preempt_delay() instead.

I am stupid. vdso_sched_preempt_delay() obviously can't write to, say,
task_struct.

Oleg.

