Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbaLWKsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:48:31 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:41433 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768AbaLWKsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:48:30 -0500
Date: Tue, 23 Dec 2014 02:48:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <kmo@daterainc.com>, Ming Lin <mlin@minggr.net>,
        Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
Subject: Re: [RFC PATCH 12/17] md/raid10: make sync_request_write() call
 bio_copy_data()
Message-ID: <20141223104830.GD27600@infradead.org>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <b7767767957ca758ac492e94dfb320bea4f52dd7.1419241597.git.dongsu.park@profitbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7767767957ca758ac492e94dfb320bea4f52dd7.1419241597.git.dongsu.park@profitbricks.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 12:48:39PM +0100, Dongsu Park wrote:
> From: Kent Overstreet <kmo@daterainc.com>
> 
> Refactor sync_request_write() of md/raid10 to use bio_copy_data()
> instead of open coding bio_vec iterations.

Seems like another one for the prep sweries?

