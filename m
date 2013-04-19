Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab3DSHpi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 03:45:38 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:34240 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab3DSHpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 03:45:36 -0400
Date: Fri, 19 Apr 2013 09:37:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-arch@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v4 0/4]  mutex: Improve mutex performance by doing less
 atomic-ops & better spinning
Message-ID: <20130419073731.GD20897@gmail.com>
References: <1366226594-5506-1-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366226594-5506-1-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <Waiman.Long@hp.com> wrote:

> v3->v4
>  - Merge patch 4 into patch 2
>  - Move patch 5 forward to become patch 1
> 
> v2->v3
>   - Add patch 4 to remove new typedefs introduced in patch 2.
>   - Add patch 5 to remove SCHED_FEAT_OWNER_SPIN and move the mutex
>     spinning code to mutex.c.
> 
> v1->v2
>  - Remove the 2 mutex spinner patches and replaced it by another one
>    to improve the mutex spinning process.
>  - Remove changes made to kernel/mutex.h & localize changes in
>    kernel/mutex.c.
>  - Add an optional patch to remove architecture specific check in patch
>    1.

The patches look pretty nice now - thanks Waiman. I have applied them to 
tip:core/locking and started testing them.

Thanks,

	Ingo
