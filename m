Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbaDWSQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 14:16:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbaDWSQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 14:16:23 -0400
Date: Wed, 23 Apr 2014 14:16:12 -0400
From: Dave Jones <davej@redhat.com>
To: Hugh Dickins <hughd@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: 3.15rc2 hanging processes on exit.
Message-ID: <20140423181612.GA10236@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-mm <linux-mm@kvack.org>
References: <20140422180308.GA19038@redhat.com>
 <CA+55aFxjADAB80AV6qK-b4QPzP7fgog_EyH-7dSpWVgzpZmL8Q@mail.gmail.com>
 <alpine.LSU.2.11.1404221303060.6220@eggly.anvils>
 <20140423144901.GA24220@redhat.com>
 <CA+55aFziPHmSP5yjxDP6h_hRY-H2VgWZKsqC7w8+B9d9wXqn6Q@mail.gmail.com>
 <alpine.LSU.2.11.1404231057470.2678@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1404231057470.2678@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 11:11:53AM -0700, Hugh Dickins wrote:
 > > Very odd.  Does anybody see anything I missed?
 > 
 > Easily explained (correct me if I'm wrong): Dave is reporting this from
 > his testing of 3.14,

correct.

 > but Linus is looking at his 3.15-rc git tree, which now contains
 > 
 > commit 57e68e9cd65b4b8eb4045a1e0d0746458502554c
 > Author: Vlastimil Babka <vbabka@suse.cz>
 > Date:   Mon Apr 7 15:37:50 2014 -0700
 >     mm: try_to_unmap_cluster() should lock_page() before mlocking
 > 
 > precisely to fix this (long-standing but long-unnoticed) issue,
 > which Sasha reported a couple of months ago.

ah, great. as long as it's fixed, I'm happy :)

	Dave


