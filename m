Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbaJXJku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:40:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37090 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaJXJks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:40:48 -0400
Date: Fri, 24 Oct 2014 02:40:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 4/4] vfs: RWF_NONBLOCK flag for preadv2
Message-ID: <20141024094047.GD29178@infradead.org>
References: <cover.1413923420.git.milosz@adfin.com>
 <ba8d704a12c7ceffce610fc438a0af11a3422002.1413923420.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba8d704a12c7ceffce610fc438a0af11a3422002.1413923420.git.milosz@adfin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 04:46:59PM -0400, Milosz Tanski wrote:
> Filesystems that generic_file_read_iter will not be allowed to perform
> non-blocking reads. This only will read data if it's in the page cache and if
> there is no page error (causing a re-read).

I can't quite parse the first sentence, can you try to reword it?

> Christoph Hellwig wrote the filesystem specify code (cifs, ofs, shm, xfs).

s/specify/specific/.  It's so trivial that I don't think it matters.

