Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532AbaJVWtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 18:49:52 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:58356 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932743AbaJVWtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 18:49:51 -0400
Date: Wed, 22 Oct 2014 15:49:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Aaron Tomlin <atomlin@redhat.com>, Dario Faggioli <raistlin@linux.it>,
        Andi Kleen <ak@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@fb.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] sysctl: terminate strings also on \r
In-Reply-To: <20141021202137.GA20114@www.outflux.net>
Message-ID: <alpine.DEB.2.02.1410221549390.28061@chino.kir.corp.google.com>
References: <20141021202137.GA20114@www.outflux.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014, Kees Cook wrote:

> From: Paul Wise <pabs3@bonedaddy.net>
> 
> This partially mitigates a common strategy used by attackers for hiding
> the full contents of strings in procfs from naive sysadmins who use cat,
> more or sysctl to inspect the contents of strings in procfs.
> 
> References: http://www.jakoblell.com/blog/2014/05/07/hacking-contest-hiding-stuff-from-the-terminal/
> Signed-off-by: Paul Wise <pabs3@bonedaddy.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: David Rientjes <rientjes@google.com>
