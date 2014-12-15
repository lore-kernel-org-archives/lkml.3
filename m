Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750945AbaLOKqI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 05:46:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:38087 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaLOKqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 05:46:07 -0500
Date: Mon, 15 Dec 2014 11:45:49 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com,
        borntraeger@de.ibm.com, mst@redhat.com, tglx@linutronix.de,
        David.Laight@ACULAB.COM, hughd@google.com, hocko@suse.cz
Subject: Re: [PATCH v2 0/5] Reenable might_sleep() checks for might_fault()
Message-ID: <20141215104549.GY29390@twins.programming.kicks-ass.net>
References: <1418221414-60110-1-git-send-email-dahi@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418221414-60110-1-git-send-email-dahi@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 03:23:29PM +0100, David Hildenbrand wrote:

Did you look at the -rt patches where this comes from?

https://git.kernel.org/cgit/linux/kernel/git/clrkwllms/rt-linux.git/commit/?h=v3.14.21-rt9&id=b389ced19ab649438196d132768fe6522d2f052b
https://git.kernel.org/cgit/linux/kernel/git/clrkwllms/rt-linux.git/commit/?h=v3.14.21-rt9&id=4fb7f9d416f7b34036d9d1b209e77c462ac0ee10
https://git.kernel.org/cgit/linux/kernel/git/clrkwllms/rt-linux.git/commit/?h=v3.14.21-rt9&id=c730a4aade9e5c9b84f65de01d6612bf70c577e3
https://git.kernel.org/cgit/linux/kernel/git/clrkwllms/rt-linux.git/commit/?h=v3.14.21-rt9&id=d365f5bf933e988a39874b33302f02ff6c7989b7
https://git.kernel.org/cgit/linux/kernel/git/clrkwllms/rt-linux.git/commit/?h=v3.14.21-rt9&id=93eb18f43dfa5d49d99e2b8ad236eea2c35dd539
https://git.kernel.org/cgit/linux/kernel/git/clrkwllms/rt-linux.git/commit/?h=v3.14.21-rt9&id=8947442e896921e1b645f9e1fd0f2beee103bba0


