Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245AbaLOMsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:48:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:38825 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaLOMsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 07:48:38 -0500
Date: Mon, 15 Dec 2014 13:48:22 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: "LF.Tan" <lftan.linux@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>, benh@kernel.crashing.org,
        paulus@samba.org, akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com, borntraeger@de.ibm.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, David.Laight@aculab.com,
        hughd@google.com, hocko@suse.cz
Subject: Re: [PATCH v2 1/5] uaccess: add pagefault_count to thread_info
Message-ID: <20141215124822.GH21343@twins.programming.kicks-ass.net>
References: <1418221414-60110-1-git-send-email-dahi@linux.vnet.ibm.com>
 <1418221414-60110-2-git-send-email-dahi@linux.vnet.ibm.com>
 <CAFiDJ59Y9y4VrcVfyo8rrQV-NtM=1G=kQScBtEvnuC3MpXt0KA@mail.gmail.com>
 <20141215122301.0eac5f19@thinkpad-w530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215122301.0eac5f19@thinkpad-w530>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 12:23:01PM +0100, David Hildenbrand wrote:
> Peter just showed my that there is some work ongoing on that
> pagefault_disable() topic. So I am not sure if the arch-specific part of this
> series is still relevant.

Well 'on-going' would be over stating it. We did those bits in -rt many
years ago, but never really made a strong enough effort to get them
upstream.

If there now is a 'semi' sane use-case for upstreaming them we should
indeed look at that.
