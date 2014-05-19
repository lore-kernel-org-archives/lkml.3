Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605AbaESNBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:01:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59051 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753843AbaESNBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:01:16 -0400
Date: Mon, 19 May 2014 15:01:14 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Kenny Simpson <theonetruekenny@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Armin Rigo <arigo@tunes.org>
Subject: Re: remap_file_pages() use
Message-ID: <20140519130114.GA3140@dhcp22.suse.cz>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCing Kirill and other people involved]

On Sun 18-05-14 00:03:28, Kenny Simpson wrote:
> I saw that remap_file_pages() was possibly going away to be replaced
> by some emulation. I've used this call in several projects over the
> years mostly as a way of mapping multiple virtual memory pages to
> alias the same private or shared memory region (to do things like
> circular buffers). mmap()
> in the case of anonymous memory doesn't work as well since there is
> not a file descriptor to reference.
> 
> Would this sort of thing be supported in the emulation, or should I be
> planning on reimplementing/rewriting some things?
> 
> thanks,
> -Kenny
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
