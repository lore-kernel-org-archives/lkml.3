Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbaESObT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:31:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53942 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaESObS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:31:18 -0400
Date: Mon, 19 May 2014 07:31:15 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: time to move fs/bio.c to block/ ?
Message-ID: <20140519143115.GA568@infradead.org>
References: <20140519141309.GB21570@infradead.org>
 <537A11CC.5060708@kernel.dk>
 <20140519142519.GI18016@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140519142519.GI18016@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 03:25:19PM +0100, Al Viro wrote:
> While you are at it, could you take bio-integrity.c with it?  _That_
> has zero excuse being anywhere in fs/* - not even "filesystem code
> uses quite a few functions from that sucker" as with bio.c.
> FWIW, consider the move ACKed.

Various function in there aren't used at all in fact. But yes, it should
also move.
