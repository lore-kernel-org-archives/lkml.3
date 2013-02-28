Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab3B1XqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 18:46:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3B1XqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 18:46:22 -0500
Date: Thu, 28 Feb 2013 15:46:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 00/10] ipc MSG_COPY fixes
Message-Id: <20130228154620.a6d87ad8.akpm@linux-foundation.org>
In-Reply-To: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
References: <1361845307-12737-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2013 21:21:37 -0500
Peter Hurley <peter@hurleysoftware.com> wrote:

> Over the weekend testing with trinity on KVM, I hit a similar oops
> (pasted below) to what others have already reported here
>      http://lkml.indiana.edu/hypermail/linux/kernel/1302.2/01465.html
> 
> While trying to uncover the underlying cause of the list corruption,
> I uncovered two other bugs which are addressed in
>   ipc: Fix potential oops when src msg > 4k w/ MSG_COPY
>   ipc: Don't allocate a copy larger than max
> 
> The other cleanup was incidental to trying to uncover the oops (so far
> unsuccessfully).

afacit, only the above two are needed in 3.9 and 3.8.x, agree?

The changelog for "ipc: Don't allocate a copy larger than max" is
rather poor - it doesn't actually describe the bug's effects, so people
will have trouble understanding whether they need the patch in their
kernels.  Can you please send along some additional description of this
one?


