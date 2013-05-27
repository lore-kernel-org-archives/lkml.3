Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab3E0Qfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 12:35:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46925 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab3E0Qfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 12:35:37 -0400
Date: Mon, 27 May 2013 18:35:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-mm@kvack.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3-resend 00/11] uaccess: better might_sleep/might_fault
 behavior
Message-ID: <20130527163530.GB19373@twins.programming.kicks-ass.net>
References: <1369575487-26176-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369575487-26176-1-git-send-email-mst@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 05:21:30PM +0300, Michael S. Tsirkin wrote:
> If the changes look good, would sched maintainers
> please consider merging them through sched/core because of the
> interaction with the scheduler?
> 
> Please review, and consider for 3.11.

I'll stick them in my queue, we'll see if anything falls over ;-)
