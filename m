Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbaLWKoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:44:05 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:40919 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbaLWKoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:44:03 -0500
Date: Tue, 23 Dec 2014 02:44:01 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <kmo@daterainc.com>, Ming Lin <mlin@minggr.net>,
        Doug Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [RFC PATCH 07/17] block: replace sg_iovec with iov_iter
Message-ID: <20141223104401.GB27600@infradead.org>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <fc859b23b383f6f4c1e81f4210aa62cb1bdc935f.1419241597.git.dongsu.park@profitbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc859b23b383f6f4c1e81f4210aa62cb1bdc935f.1419241597.git.dongsu.park@profitbricks.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does this and the next three patches really depend on the earlier ones?
Unless I'm missing something they are cleanups on their own.

It might make sense to get all these cleanups out as a preparatory
series first.

