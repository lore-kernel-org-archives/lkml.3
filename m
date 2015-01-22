Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbbAVHqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:46:21 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:54696 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbbAVHqN (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 22 Jan 2015 02:46:13 -0500
Message-ID: <1421912761.4903.22.camel@stgolabs.net>
Subject: Re: [PATCH] mm, vmacache: Add kconfig VMACACHE_SHIFT
From: Davidlohr Bueso <dave@stgolabs.net>
To: WANG Chao <chaowang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Wed, 21 Jan 2015 23:46:01 -0800
In-Reply-To: <1421908189-18938-1-git-send-email-chaowang@redhat.com>
References: <1421908189-18938-1-git-send-email-chaowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-22 at 14:29 +0800, WANG Chao wrote:
> Add a new kconfig option VMACACHE_SHIFT (as a power of 2) to specify the
> number of slots vma cache has for each thread. Range is chosen 0-4 (1-16
> slots) to consider both overhead and performance penalty. Default is 2
> (4 slots) as it originally is, which provides good enough balance.
> 

Nack. I don't feel comfortable making scalability features of core code
configurable.

Thanks,
Davidlohr



