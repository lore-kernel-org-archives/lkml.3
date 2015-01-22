Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbbAVH6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 02:58:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751990AbbAVH6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 02:58:19 -0500
Date: Thu, 22 Jan 2015 15:57:42 +0800
From: WANG Chao <chaowang@redhat.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm, vmacache: Add kconfig VMACACHE_SHIFT
Message-ID: <20150122075742.GA11335@dhcp-129-179.nay.redhat.com>
References: <1421908189-18938-1-git-send-email-chaowang@redhat.com>
 <1421912761.4903.22.camel@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421912761.4903.22.camel@stgolabs.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Davidlohr

On 01/21/15 at 11:46pm, Davidlohr Bueso wrote:
> On Thu, 2015-01-22 at 14:29 +0800, WANG Chao wrote:
> > Add a new kconfig option VMACACHE_SHIFT (as a power of 2) to specify the
> > number of slots vma cache has for each thread. Range is chosen 0-4 (1-16
> > slots) to consider both overhead and performance penalty. Default is 2
> > (4 slots) as it originally is, which provides good enough balance.
> > 
> 
> Nack. I don't feel comfortable making scalability features of core code
> configurable.

Out of respect, is this a general rule not making scalability features
of core code configurable?

Thanks
WANG Chao
