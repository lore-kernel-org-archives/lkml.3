Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbaESQ4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:56:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49089 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869AbaESQ4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:56:41 -0400
Date: Mon, 19 May 2014 09:56:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Kenny Simpson <theonetruekenny@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Armin Rigo <arigo@tunes.org>
Subject: Re: remap_file_pages() use
Message-ID: <20140519165637.GA663@infradead.org>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
 <20140519130114.GA3140@dhcp22.suse.cz>
 <20140519143540.BE9F6E009B@blue.fi.intel.com>
 <20140519143837.GA5228@infradead.org>
 <20140519150238.67898E009B@blue.fi.intel.com>
 <20140519151104.GA16736@infradead.org>
 <20140519151758.A2162E009B@blue.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519151758.A2162E009B@blue.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 06:17:58PM +0300, Kirill A. Shutemov wrote:
> IIUC PyPy uses the syscall in some early prototype and looks like guys are
> okay to rework it to mmap() if default sysctl_max_map_count will be high
> enough.

My point is that we already found a few users just by discussing the
issue on lkml, and thus establishing that a) there are users outside of
Oracle, and b) there probably will be lots more that we don't even know
about.

