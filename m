Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751502AbaL0PDa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 10:03:30 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:41252 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbaL0PD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 10:03:26 -0500
Date: Sat, 27 Dec 2014 07:03:25 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Ming Lin <mlin@minggr.net>, Doug Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [RFC PATCH 07/17] block: replace sg_iovec with iov_iter
Message-ID: <20141227150325.GD1094@infradead.org>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <fc859b23b383f6f4c1e81f4210aa62cb1bdc935f.1419241597.git.dongsu.park@profitbricks.com>
 <20141223104401.GB27600@infradead.org>
 <20141223121815.GE15080@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141223121815.GE15080@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 01:18:15PM +0100, Dongsu Park wrote:
> I think so too. Patches #07-10 can be split into a separate patchset.
> I guess they are included just because Kent tried to follow up
> suggestions in the previous discussion.
> I don't care about either way. So I'll split them up.

In case I wasn't quite clear:  I'd prefer you to send the patches that
just clean existing code and API use first, and then the bio splitting
series on top of that.
