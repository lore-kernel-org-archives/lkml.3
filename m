Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaBJXCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 18:02:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59419 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbaBJXCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 18:02:33 -0500
Date: Mon, 10 Feb 2014 15:02:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Waiman Long <waiman.long@hp.com>, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de, riel@redhat.com, davidlohr@hp.com, hpa@zytor.com,
        andi@firstfloor.org, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 0/8] locking/core patches
Message-Id: <20140210150230.b7f46688093ebc5c45fee870@linux-foundation.org>
In-Reply-To: <20140210195820.834693028@infradead.org>
References: <20140210195820.834693028@infradead.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014 20:58:20 +0100 Peter Zijlstra <peterz@infradead.org> wrote:

> Hi all,
> 
> I would propose merging the following patches...
> 
> The first set is mostly from Jason and tweaks the mutex adaptive
> spinning, AIM7 throughput numbers:
> 
> PRE:  100   2000.04  21564.90 2721.29 311.99     3.12       0.01     0.00     99
> POST: 100   2000.04  42603.85 5142.80 311.99     3.12       0.00     0.00     99

What do these columns represent?  I'm guessing the large improvement
was in context switches?

> The second set is the qrwlock, although mostly rewritten by me. I didn't do
> much with it other than boot and build a kernel. But I like them because
> of the much better worst case preformance.
