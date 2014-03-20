Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbaCTB4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 21:56:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:61596 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888AbaCTB4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 21:56:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,690,1389772800"; 
   d="scan'208";a="476076842"
Date: Wed, 19 Mar 2014 18:56:34 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Aaron Tomlin <atomlin@redhat.com>,
        Andrew Shewmaker <agshew@gmail.com>, Li Zefan <lizefan@huawei.com>,
        Dario Faggioli <raistlin@linux.it>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sysctl: fix incorrect write position handling
Message-ID: <20140320015634.GH3132@tassilo.jf.intel.com>
References: <1395163080-6290-1-git-send-email-keescook@chromium.org>
 <1395163080-6290-2-git-send-email-keescook@chromium.org>
 <20140319152521.04fe6665c67efe0c6a70d8a5@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140319152521.04fe6665c67efe0c6a70d8a5@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Why are we fixing this?

Also sysctl writes are root only anyways.

Protecting root against root? Seems odd.

-Andi
