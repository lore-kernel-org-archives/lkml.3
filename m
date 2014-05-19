Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbaESPLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 11:11:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39772 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbaESPLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 11:11:12 -0400
Date: Mon, 19 May 2014 08:11:04 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Kenny Simpson <theonetruekenny@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Armin Rigo <arigo@tunes.org>
Subject: Re: remap_file_pages() use
Message-ID: <20140519151104.GA16736@infradead.org>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
 <20140519130114.GA3140@dhcp22.suse.cz>
 <20140519143540.BE9F6E009B@blue.fi.intel.com>
 <20140519143837.GA5228@infradead.org>
 <20140519150238.67898E009B@blue.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519150238.67898E009B@blue.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 06:02:38PM +0300, Kirill A. Shutemov wrote:
> > Stop right there.  We found out about two real life users of
> > remap_file_pages() already, without even committing the patches to warn
> > about using it to any tree.
> 
> Who is the second here?	Oracle?

PyPy.

Oracle would be the third, although use of the feature is optional and
fairly hard to opt in to, so I didn't count it.
