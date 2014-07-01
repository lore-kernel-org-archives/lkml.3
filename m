Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168AbaGAQGC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:06:02 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:13979 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756201AbaGAQGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:06:01 -0400
Message-ID: <1404230760.25766.5.camel@hornet>
Subject: Re: [PATCH v2] perf: Handle compat ioctl
From: Pawel Moll <pawel.moll@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Drew Richardson <Drew.Richardson@arm.com>
Date: Tue, 01 Jul 2014 17:06:00 +0100
In-Reply-To: <1403009029-30967-1-git-send-email-pawel.moll@arm.com>
References: <20140617121328.GO3213@twins.programming.kicks-ass.net>
	 <1403009029-30967-1-git-send-email-pawel.moll@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-17 at 13:43 +0100, Pawel Moll wrote:
> When running a 32-bit userspace on a 64-bit kernel (eg. i386
> application on x86_64 kernel or 32-bit arm userspace on arm64
> kernel) some of the perf ioctls must be treated with special
> care, as they have a pointer size encoded in the command.
> 
> For example, PERF_EVENT_IOC_ID in 32-bit world will be encoded
> as 0x80042407, but 64-bit kernel will expect 0x80082407. In
> result the ioctl will fail returning -ENOTTY.
> 
> This patch solves the problem by adding code fixing up the
> size as compat_ioctl file operation.
> 
> Reported-by: Drew Richardson <drew.richardson@arm.com>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>

This just is a polite and friendly nag...

Any, strong or not, opinions on the matter?

Cheers!

Pawel

