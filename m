Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965991Ab3DQHRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 03:17:31 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:41599 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965736Ab3DQHR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 03:17:29 -0400
Date: Wed, 17 Apr 2013 09:17:24 +0200
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
Subject: Re: [PATCH v3 4/5] mutex: Remove new typedefs introduced in patch 2
Message-ID: <20130417071724.GA21051@gmail.com>
References: <1366172891-7729-1-git-send-email-Waiman.Long@hp.com>
 <1366172891-7729-5-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366172891-7729-5-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <Waiman.Long@hp.com> wrote:

> In response to the review comment from Davidlohr, this patch will
> remove the new typedefs introduced by patch 2. It also removes an
> unnecessary barrier() call.

Please backmerge this fix of patch #2 into patch #2, that reduces the number of 
patches by one.

Thanks,

	Ingo
