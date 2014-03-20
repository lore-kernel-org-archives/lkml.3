Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933484AbaCTLyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:54:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374AbaCTLym (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:54:42 -0400
Date: Thu, 20 Mar 2014 10:09:54 +0000
From: Aaron Tomlin <atomlin@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Andrew Shewmaker <agshew@gmail.com>,
        Li Zefan <lizefan@huawei.com>, Dario Faggioli <raistlin@linux.it>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sysctl: fix incorrect write position handling
Message-ID: <20140320100954.GD4701@atomlin.usersys.redhat.com>
References: <1395163080-6290-1-git-send-email-keescook@chromium.org>
 <1395163080-6290-2-git-send-email-keescook@chromium.org>
 <20140319152521.04fe6665c67efe0c6a70d8a5@linux-foundation.org>
 <20140320015634.GH3132@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140320015634.GH3132@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 06:56:34PM -0700, Andi Kleen wrote:
> > 
> > Why are we fixing this?
> 
> Also sysctl writes are root only anyways.
> 
> Protecting root against root? Seems odd.
> 
> -Andi

I agree. I don't see the point here.

Regards,

-- 
Aaron Tomlin
