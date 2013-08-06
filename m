Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab3HFQGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 12:06:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823Ab3HFQF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 12:05:58 -0400
Message-ID: <52011E99.8030708@redhat.com>
Date: Tue, 06 Aug 2013 12:04:41 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alex Thorlton <athorlton@sgi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCHv2] Add per-process flag to control thp
References: <20130802205735.GS26476@sgi.com> <20130805160306.a620c88ba9098b98a0f93665@linux-foundation.org> <20130806150807.GA2456@sgi.com>
In-Reply-To: <20130806150807.GA2456@sgi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 11:08 AM, Alex Thorlton wrote:

> Thanks, Andrew.  I'm doing some more testing and looking into using a
> different method for controlling this.  At this point, I think it's fair
> to say that we don't want to control this using the method that I've
> proposed here, no matter how we look at it.

Considering that we have both mlock and mlockall, it
is not totally crazy to also have both madvise and
madviseall.

Just saying... :)

-- 
All rights reversed
