Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932210AbaESOeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:34:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56676 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaESOeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:34:18 -0400
Date: Mon, 19 May 2014 07:34:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: time to move fs/bio.c to block/ ?
Message-ID: <20140519143416.GC568@infradead.org>
References: <20140519141309.GB21570@infradead.org>
 <537A11CC.5060708@kernel.dk>
 <20140519142519.GI18016@ZenIV.linux.org.uk>
 <537A15B9.6000102@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537A15B9.6000102@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 08:31:21AM -0600, Jens Axboe wrote:
> > While you are at it, could you take bio-integrity.c with it?  _That_
> > has zero excuse being anywhere in fs/* - not even "filesystem code
> > uses quite a few functions from that sucker" as with bio.c.
> > FWIW, consider the move ACKed.
> 
> Yeah, I did include that in the move.

Other candidates to move to block/ might be ioprio.c and no-block.c

