Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbaJXJiF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 05:38:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35900 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaJXJiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 05:38:03 -0400
Date: Fri, 24 Oct 2014 02:38:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 3/4] vfs: Export new vector IO syscalls (with flags) to
 userland
Message-ID: <20141024093802.GC29178@infradead.org>
References: <cover.1413923420.git.milosz@adfin.com>
 <e43b43c1e7b14b454b6425a650cd45cbb75fd325.1413923420.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e43b43c1e7b14b454b6425a650cd45cbb75fd325.1413923420.git.milosz@adfin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 04:46:58PM -0400, Milosz Tanski wrote:
> This is only for x86_64 and x86. Will add other arch later.

Looks good, but I think the patch subject should read something like:

x86: wite up preadv2 and pwritev2

in which case you might also get away with an empty description.

Please also Cc linux-arch to get the attention of other architecture
maintainers for the next repost.

Reviewed-by: Christoph Hellwig <hch@lst.de>
