Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab3LIXyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:54:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab3LIXyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:54:11 -0500
Message-ID: <52A657EC.6080304@redhat.com>
Date: Mon, 09 Dec 2013 18:53:16 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Biederman <ebiederm@xmission.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        kexec@lists.infradead.org
Subject: Re: [PATCH] kexec: add sysctl to disable kexec
References: <20131209233829.GA3501@www.outflux.net>
In-Reply-To: <20131209233829.GA3501@www.outflux.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 06:38 PM, Kees Cook wrote:
> For general-purpose (i.e. distro) kernel builds it makes sense to build with
> CONFIG_KEXEC to allow end users to choose what kind of things they want to do
> with kexec. However, in the face of trying to lock down a system with such
> a kernel, there needs to be a way to disable kexec (much like module loading
> can be disabled). Without this, it is too easy for the root user to modify
> kernel memory even when CONFIG_STRICT_DEVMEM and modules_disabled are set.

Not everybody will be running with selinux, or another LSM security
policy, so having this simple knob probably makes sense.

OTOH, are the people who run without a fancy security people the
same people who are interested in locking down the system?

I guess I'll ack the patch, since I see no real downside to having
the knob...

> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
